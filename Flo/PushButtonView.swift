import UIKit

@IBDesignable
class PushButtonView: UIButton {
  
  @IBInspectable var fillColor: UIColor = UIColor.green
  @IBInspectable var isAddButton: Bool = true
  
  //need to override highlighted
  //to call setNeedsDisplay() when the button is pressed
  
  override var isHighlighted:Bool {
    didSet {
      super.isHighlighted = isHighlighted
      setNeedsDisplay()
    }
  }

  
  override func draw(_ rect: CGRect) {
    
    let path = UIBezierPath(ovalIn: rect)
    fillColor.setFill()
    path.fill()
    
    //set up the width and height variables
    //for the horizontal stroke
    let plusHeight: CGFloat = 3.0
    let plusWidth: CGFloat = min(bounds.width, bounds.height) * 0.6
    
    //create the path
    let plusPath = UIBezierPath()
    
    //set the path's line width to the height of the stroke
    plusPath.lineWidth = plusHeight
    
    //move the initial point of the path
    //to the start of the horizontal stroke
    plusPath.move(to: CGPoint(
      x:bounds.width/2 - plusWidth/2 + 0.5,
      y:bounds.height/2 + 0.5))
    
    //add a point to the path at the end of the stroke
    plusPath.addLine(to: CGPoint(
      x:bounds.width/2 + plusWidth/2 + 0.5,
      y:bounds.height/2 + 0.5))
    
    //Vertical Line
    if isAddButton {
      //move to the start of the vertical stroke
      plusPath.move(to: CGPoint(
        x:bounds.width/2 + 0.5,
        y:bounds.height/2 - plusWidth/2 + 0.5))
      
      //add the end point to the vertical stroke
      plusPath.addLine(to: CGPoint(
        x:bounds.width/2 + 0.5,
        y:bounds.height/2 + plusWidth/2 + 0.5))
    }
    
    //set the stroke color
    UIColor.white.setStroke()
    
    //draw the stroke
    plusPath.stroke()
    
    //gradient and blending
    //gives user feedback on pressing a button
    //need to override the highlighted property (see above)
    //to call setNeedsDisplay()
    
    if self.state == .highlighted {
      let context = UIGraphicsGetCurrentContext()
      let startColor = UIColor.clear
      let endColor = UIColor(hue: 0, saturation: 0, brightness: 0, alpha: 0.15)
      let colors = [startColor.cgColor, endColor.cgColor]
      let colorSpace = CGColorSpaceCreateDeviceRGB()
      let colorLocations:[CGFloat] = [0.0, 1.0]
      let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: colorLocations)
      let center = CGPoint(x: rect.midX, y: rect.midY)
      let radius = self.bounds.width/2
      context?.setBlendMode(.darken)
      context?.drawRadialGradient(gradient!, startCenter: center, startRadius: 0, endCenter: center, endRadius: radius, options: CGGradientDrawingOptions(rawValue: 0))
    }

  }
  
}
