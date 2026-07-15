//
//  AIBotService.swift
//  CareMate
//
//  Networking layer for the AI symptom-assistant ("Chat Voice") backend,
//  ported from the Android VoiceAiServices/VoiceAiViewModel implementation.
//
//  Base: http://41.33.82.156:22870/patient-chatbot/
//  (plain HTTP is allowed — Info.plist sets NSAllowsArbitraryLoads).
//

import Foundation

// MARK: - Models

/// POST /generate-session  (empty body)
struct AIBotSession: Codable {
    let session_key: String?
}

/// POST /set_conversation_language  { lang, session_key } -> String
struct SetLanguageRequest: Codable {
    let lang: String
    let session_key: String
}

/// POST /medical_conversation_v2  { question, user_response, session_key }
struct MedicalConversationRequest: Codable {
    let question: String?
    let user_response: String
    let session_key: String
}

struct ConversationInfo: Codable {
    let diagnosis: String?
    let recommended_speciality: String?
    let recommended_speciality_code: String?
}

struct MedicalConversationResponse: Codable {
    let content: String?
    let is_conversation_finished: Bool?
    let conversation_info: ConversationInfo?
}

/// POST /speech-to-text  (multipart audio_file + ?session_key)
struct SpeechToTextResponse: Codable {
    let transcription: String?
}

/// POST /text_to_speech_v2  { text, session_key } -> streamed mp3
struct TextToSpeechRequest: Codable {
    let text: String
    let session_key: String
}

/// POST /reset_info and /close-session  { session_key }
struct ResetInfoRequest: Codable {
    let session_key: String
}

/// POST /book_doctor_appointment
struct BookDoctorRequest: Codable {
    let session_key: String
    var user_response: String?
    var speciality_name: String?
    var speciality_code: String?
}

struct BookDoctorResponse: Codable {
    let content: String?
    let is_conversation_finished: Bool?
    let date: String?
    let doctor_type: Int?
    let doctor_gender_preference: Int?
    let specialty_name: String?
    let specialty_code: String?
}

// MARK: - Errors

enum AIBotServiceError: Error {
    case invalidURL
    case noData
    case http(Int)
    case decoding(Error)
    case transport(Error)

    /// Short human-readable reason (used for on-screen debugging).
    var debugText: String {
        switch self {
        case .invalidURL: return "invalid url"
        case .noData: return "no data"
        case .http(let code): return "HTTP \(code)"
        case .decoding: return "bad response format"
        case .transport(let error): return "network: \(error.localizedDescription)"
        }
    }
}

// MARK: - Service

final class AIBotService {

    static let shared = AIBotService()
    private init() {}

    private let base = "http://41.33.82.156:22870/patient-chatbot/"
    private let session = URLSession(configuration: .default)

    private enum Path: String {
        case generateSession = "generate-session"
        case setLanguage = "set_conversation_language"
        case speechToText = "speech-to-text"
        case medicalConversation = "medical_conversation_v2"
        case textToSpeech = "text_to_speech_v2"
        case resetInfo = "reset_info"
        case closeSession = "close-session"
        case bookDoctor = "book_doctor_appointment"
    }

    // MARK: Endpoints

    func generateSession(completion: @escaping (Result<AIBotSession, AIBotServiceError>) -> Void) {
        postJSON(.generateSession, body: Optional<Int>.none, completion: completion)
    }

    func setLanguage(lang: String, sessionKey: String,
                     completion: @escaping (Result<String, AIBotServiceError>) -> Void) {
        // Response is a plain string, not JSON.
        postRaw(.setLanguage, body: SetLanguageRequest(lang: lang, session_key: sessionKey)) { result in
            switch result {
            case .success(let data):
                let text = String(data: data, encoding: .utf8) ?? ""
                completion(.success(text))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func medicalConversation(_ request: MedicalConversationRequest,
                             completion: @escaping (Result<MedicalConversationResponse, AIBotServiceError>) -> Void) {
        postJSON(.medicalConversation, body: request, completion: completion)
    }

    func bookDoctorConversation(_ request: BookDoctorRequest,
                                completion: @escaping (Result<BookDoctorResponse, AIBotServiceError>) -> Void) {
        postJSON(.bookDoctor, body: request, completion: completion)
    }

    func resetInfo(sessionKey: String, completion: @escaping (Result<Void, AIBotServiceError>) -> Void) {
        postRaw(.resetInfo, body: ResetInfoRequest(session_key: sessionKey)) { completion($0.map { _ in () }) }
    }

    func closeSession(sessionKey: String, completion: @escaping (Result<Void, AIBotServiceError>) -> Void) {
        postRaw(.closeSession, body: ResetInfoRequest(session_key: sessionKey)) { completion($0.map { _ in () }) }
    }

    /// Returns the spoken audio saved to a temp .mp3 file URL, ready for playback.
    func textToSpeech(text: String, sessionKey: String,
                      completion: @escaping (Result<URL, AIBotServiceError>) -> Void) {
        postRaw(.textToSpeech, body: TextToSpeechRequest(text: text, session_key: sessionKey)) { result in
            switch result {
            case .success(let data):
                let url = FileManager.default.temporaryDirectory
                    .appendingPathComponent("aibot_\(UUID().uuidString).mp3")
                do {
                    try data.write(to: url)
                    completion(.success(url))
                } catch {
                    completion(.failure(.transport(error)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    /// Uploads a recorded audio file, returns the transcription.
    func speechToText(fileURL: URL, sessionKey: String,
                      completion: @escaping (Result<SpeechToTextResponse, AIBotServiceError>) -> Void) {
        guard var components = URLComponents(string: base + Path.speechToText.rawValue) else {
            completion(.failure(.invalidURL)); return
        }
        components.queryItems = [URLQueryItem(name: "session_key", value: sessionKey)]
        guard let url = components.url else { completion(.failure(.invalidURL)); return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        guard let fileData = try? Data(contentsOf: fileURL) else {
            completion(.failure(.noData)); return
        }
        var body = Data()
        let filename = fileURL.lastPathComponent
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"audio_file\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: audio/wav\r\n\r\n")
        body.append(fileData)
        body.appendString("\r\n--\(boundary)--\r\n")
        request.httpBody = body

        run(request, completion: completion)
    }

    // MARK: - Core request helpers

    private func makeRequest(_ path: Path) -> URLRequest? {
        guard let url = URL(string: base + path.rawValue) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }

    /// POST a JSON body and decode a JSON response.
    private func postJSON<Body: Encodable, Response: Decodable>(
        _ path: Path, body: Body?,
        completion: @escaping (Result<Response, AIBotServiceError>) -> Void
    ) {
        guard var request = makeRequest(path) else { completion(.failure(.invalidURL)); return }
        if let body = body {
            request.httpBody = try? JSONEncoder().encode(body)
        } else {
            request.httpBody = Data() // empty body (e.g. generate-session)
        }
        run(request, completion: completion)
    }

    /// POST a JSON body and return the raw response bytes (string / mp3 / void).
    private func postRaw<Body: Encodable>(
        _ path: Path, body: Body,
        completion: @escaping (Result<Data, AIBotServiceError>) -> Void
    ) {
        guard var request = makeRequest(path) else { completion(.failure(.invalidURL)); return }
        request.httpBody = try? JSONEncoder().encode(body)
        runRaw(request, completion: completion)
    }

    private func run<Response: Decodable>(
        _ request: URLRequest,
        completion: @escaping (Result<Response, AIBotServiceError>) -> Void
    ) {
        runRaw(request) { result in
            switch result {
            case .success(let data):
                do {
                    let decoded = try JSONDecoder().decode(Response.self, from: data)
                    completion(.success(decoded))
                } catch {
                    let body = String(data: data, encoding: .utf8) ?? "<binary>"
                    print("🔴 [AIBot] DECODING FAILED for \(Response.self): \(error)\n   body: \(body)")
                    completion(.failure(.decoding(error)))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func runRaw(_ request: URLRequest,
                        completion: @escaping (Result<Data, AIBotServiceError>) -> Void) {
        let path = request.url?.lastPathComponent ?? "?"
        if let body = request.httpBody, let str = String(data: body, encoding: .utf8) {
            print("➡️ [AIBot] POST \(path)  body: \(str)")
        } else {
            print("➡️ [AIBot] POST \(path)")
        }
        session.dataTask(with: request) { data, response, error in
            let status = (response as? HTTPURLResponse)?.statusCode ?? -1
            let bodyStr = data.flatMap { String(data: $0, encoding: .utf8) } ?? "<\(data?.count ?? 0) bytes>"
            print("⬅️ [AIBot] \(path)  status \(status)  resp: \(bodyStr.prefix(500))")
            let finish: (Result<Data, AIBotServiceError>) -> Void = { result in
                DispatchQueue.main.async { completion(result) }
            }
            if let error = error {
                print("🔴 [AIBot] \(path) transport error: \(error.localizedDescription)")
                finish(.failure(.transport(error))); return
            }
            if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
                finish(.failure(.http(http.statusCode))); return
            }
            finish(.success(data ?? Data()))
        }.resume()
    }
}

private extension Data {
    mutating func appendString(_ string: String) {
        if let data = string.data(using: .utf8) { append(data) }
    }
}
