//
//  HospitalStoryViewController.swift
//  CareMate
//
//  Created by Khabber on 03/07/2022.
//  Copyright © 2022 khabeer Group. All rights reserved.
//

import UIKit

class HospitalStoryViewController: BaseViewController {
    
    @IBOutlet weak var uilabel1964: UILabel!
    @IBOutlet weak var uilabel1964Text: UILabel!
    @IBOutlet weak var uiView1964: UIView!

    @IBOutlet weak var uilabel1992: UILabel!
    @IBOutlet weak var uilabel1992Text: UILabel!
    @IBOutlet weak var uiView1992: UIView!

    @IBOutlet weak var uilabel2001: UILabel!
    @IBOutlet weak var uilabel2001Text: UILabel!
    @IBOutlet weak var uiView2001: UIView!

    @IBOutlet weak var uilabelNow: UILabel!
    @IBOutlet weak var uilabelNowText: UILabel!

    @IBOutlet weak var labelElsalamEllasema: UILabel!
    @IBOutlet weak var labelElsalamElahmadi: UILabel!
    @IBOutlet weak var labelNowAlahmady: UILabel!
    @IBOutlet weak var viewNowAlahmadi: UIView!
    @IBOutlet weak var viewAlahmadi: UIView!
    @IBOutlet weak var labelAlahmadi: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiView1964.addLineDashedStroke(pattern: [2,3], radius: 12)
        uiView1992.addLineDashedStroke(pattern: [2,3], radius: 12)
        uiView2001.addLineDashedStroke(pattern: [2,3], radius: 12)


        initHeader(isNotifcation: true, isLanguage: true, title: UserManager.isArabic ? "قصه المستشفي" :"Hospital Story", hideBack: false)
        if UserManager.isArabic{
            labelElsalamEllasema.text = "مستشفى السلام العاصمة"
            labelElsalamElahmadi.text = "مستشفى السلام الأحمدي"
            uilabel1964Text.text = "أسست مستشفى السلام العاصمة في عام 1964 , و كانت البداية كمشفى ولادة يحتوي على 10 أسرة , و يعمل به طبيب ولادة واحد و 5 ممرضات. و منذ ذلك الحين استمرت المستشفى في نموها من حيث الحجم و عدد الموظفين , بناءا على سمعتها بوصفها إحدى المستشفيات الخاصة الرائدة في دولة الكويت."
            uilabel1964.text = "١٩٦٤"
            uilabel1992Text.text = "في شهر مايو من عام 1992 وسعت مستشفى السلام مجال خدماتها, واكتملت لتصبح مستشفى عامة و شاملة."
            uilabel1992.text = "١٩٩٢"

            
            uilabel2001Text.text = "في شهر يناير من عام 2001 بدأ تنفيذ برنامج للتوسع يؤدي إلى البدء في تشييد المبنى الجديد , الذي اكتمل في 16 إبريل من عام 2006."
            uilabel2001.text = "٢٠٠١"

            uilabelNowText.text = "يحتوي مستشفى السلام العاصمة اليوم على 192 سريرًا وتوفر خدمات الرعاية في طب النساء والولادة والجراحة العامة وطب الأطفال وخدمات العناية المركزة. والتزامًا بشعار \"ثقتكم أمانة\" وبالاستفادة من الاعتماد الكندي لمعايير تحسين الأداء كوسيلة لتحقيق رؤيتنا ورسالتنا. يسعى مستشفى السلام الدولي دائمًا لامتلاك أحدث وسائل التكنولوجيا الحديثة وتوظيف ذوي الخبرة والكفاءات العالية من الأطباء والممرضين وفريق العمل الإداري. بالإضافة لتوفير برامج التعليم المستمرة لمواكبة الممارسات المبنية على أسس و براهين معتمدة."
            uilabelNow.text = "الان"
            labelNowAlahmady.text = "الان"
            labelAlahmadi.text = "بناءً على استراتيجية مستشفى السلام في التوسع في تقديم خدماتها الصحية المتميزة ولدعم المنظومة الصحية في دولة الكويت، تم افتتاح مستشفى السلام الأحمدي في عام 2023 ليكون إضافة جديده لعائلة مستشفيات السلام. يقع مستشفى السلام الأحمدي في منطقة المهبولة بمحافظة الأحمدي جنوب دولة الكويت لتوفير الخدمات الصحية اللازمة لسكان المنطقة والمناطق المجاورة لها، تم إنشاء المستشفى على مساحة (5304) م2، و يحتوي على ( 118) سريراً قابلة للتوسع لتقديم خدمة رعاية صحية متميزة من خلال فريق طبي مميز ذو كفاءة عالية."

        }
        else{
            labelElsalamEllasema.text = "Al-Salam Al-Assima Hospital"
            labelElsalamElahmadi.text = "Al-Salam Al-Ahmadi Hospital"
            uilabel1964Text.text = "Al-Salam Al-Assima Hospital was originally established in 1964, as a small ten bedded Maternity Hospital, staffed by one OBS/GYN Doctor and five nurses. Since then, the hospital kept growing both in size and number of staff, building on its reputation as a leading private hospital in Kuwait"
            uilabel1964.text = "1964"
            uilabel1992Text.text = " In May 1992, the hospital widened its scope of services and became a full-fledged secondary care General Hospital."
            uilabel1992.text = "1992"

            
            uilabel2001Text.text = "In January 2001, an ambitious expansion program led to the commencement of the construction of the new facility, which was commissioned on April 16th, 2006."
            uilabel2001.text = "2001"

            uilabelNowText.text = "Today, Al Salam Assima Hospital (SASH) is a 190-bed hospital, that provides Obstetric Gynecology, Surgical, Medical, Pediatric, and Critical Care Services. As a commitment to its logo statement “Trust” and utilizing the Accreditation Canada Performance Improvement Standards as a means of fulfilling the organizational mission and vision, SASH ensures the acquisition of state-of-the-art technology, recruitment of highly qualified and trained clinical and non-clinical workforce, in addition to the provision of continuing education programs and keeping abreast with evidence-based practices."
            uilabelNow.text = "Now"
            labelAlahmadi.text = "Based on Al-Salam Hospital's strategy to extend its healthcare services and to support the health system in the State of Kuwait, Al-Salam Al-Ahmadi Hospital was opened in 2023 to be a new addition to the Al-Salam Hospitals family. Al-Salam Al-Ahmadi Hospital is in the south of the State of Kuwait to provide appropriate health services to the residents of the region and the nearby areas. Al–Salam Al-Ahmadi Hospital has been established on an area of (5304) m2, with a capacity of (118) beds that are capable of expansion, to provide exceptional patient care by adopting a complete and distinguished medical team"
        }
        
    
   
    
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

public class DashedView: UIView {

    public struct Configuration {
        public var color: UIColor
        public var dashLength: CGFloat
        public var dashGap: CGFloat

        public init(
            color: UIColor,
            dashLength: CGFloat,
            dashGap: CGFloat) {
            self.color = color
            self.dashLength = dashLength
            self.dashGap = dashGap
        }

        static let `default`: Self = .init(
            color: .lightGray,
            dashLength: 7,
            dashGap: 3)
    }

    // MARK: - Properties

    /// Override to customize height
    public class var lineHeight: CGFloat { 1.0 }

    override public var intrinsicContentSize: CGSize {
        CGSize(width: UIViewNoIntrinsicMetric, height: Self.lineHeight)
    }

    public final var config: Configuration = .default {
        didSet {
            drawDottedLine()
        }
    }

    private var dashedLayer: CAShapeLayer?

    // MARK: - Life Cycle

    override public func layoutSubviews() {
        super.layoutSubviews()

        // We only redraw the dashes if the width has changed.
        guard bounds.width != dashedLayer?.frame.width else { return }

        drawDottedLine()
    }

    // MARK: - Drawing

    private func drawDottedLine() {
        if dashedLayer != nil {
            dashedLayer?.removeFromSuperlayer()
        }

        dashedLayer = drawDottedLine(
            start: bounds.origin,
            end: CGPoint(x: bounds.width, y: bounds.origin.y),
            config: config)
    }

}

// Thanks to: https://stackoverflow.com/a/49305154/4802021
private extension DashedView {
    func drawDottedLine(
        start: CGPoint,
        end: CGPoint,
        config: Configuration) -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = config.color.cgColor
        shapeLayer.lineWidth = Self.lineHeight
        shapeLayer.lineDashPattern = [config.dashLength as NSNumber, config.dashGap as NSNumber]

        let path = CGMutablePath()
        path.addLines(between: [start, end])
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)

        return shapeLayer
    }
}
extension UIView {
    @discardableResult
    func addLineDashedStroke(pattern: [NSNumber]?, radius: CGFloat) -> CALayer {
        let borderLayer = CAShapeLayer()

//        borderLayer.strokeColor = color
        borderLayer.lineDashPattern = pattern
        borderLayer.frame = bounds
        borderLayer.fillColor = nil
        borderLayer.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: radius, height: radius)).cgPath

        layer.addSublayer(borderLayer)
        return borderLayer
    }
}
