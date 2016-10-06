//: Playground - noun: a place where people can play

import Foundation


//Date 和 String 的 转换
//首先我们使用Date 获取当前日期
let currentdate = Date()

//接下来初始化DateFormatter: 用来在Date 和 String 之间相互转换
let dateformatter = DateFormatter()

// 在将 Date 转换为String 之前 你需要告诉DateFormatter 你需要显示的字符串的结果的格式

dateformatter.dateStyle = .full
dateformatter.timeStyle = .long

//这里格式有5种 根据自己的需求去设置枚举值

let dateString = dateformatter.string(from: currentdate)

//当你觉得枚举值中输出的格式 无法满足你的要求,你要自定义日期的输出格式的话.你需要格式化你的日期字符串

//EEEE:表示星期几(Monday),使用1-3个字母表示周几的缩写
//MMMM:月份的全写(October),使用1-3个字母表示月份的缩写
//dd:表示日期,使用一个字母表示没有前导0
//YYYY:四个数字的年份(2016)
//HH:两个数字表示的小时(02或21)
//mm:两个数字的分钟 (02或54)
//ss:两个数字的秒
//zzz:三个字母表示的时区


dateformatter.dateFormat = " YYYY - MM - dd HH:mm:ss"
//dateformatter.dateFormat = "hh:mm:ss"

let customDate = dateformatter.string(from: currentdate)


//把既定格式的字符串转化为Date对象

var string1 = "2016-10-05"
dateformatter.dateFormat = " YYYY - MM - dd"
var newDate = dateformatter.date(from: string1)

//很多时候你需要拆分数据对象 获取日期,时间之类的元素的值
/*NSDateComponents 通常和NSCalendar 结合起来使用 NSCalendar 方法实现了真正的从NSDate 到 NSDateComponents对象的转换
,以及从日期的组成元素到日期对象的转换.
 */

let calendar = Calendar.current

let dateComponents = calendar.dateComponents([.year,.month, .day, .hour,.minute,.second], from: currentdate)

dateComponents.year
dateComponents.day

//从dateComponents 转化为 Date 

var components = DateComponents()
components.year = 2016
components.day = 10
components.month = 11
//你也可以设置时区 使用TimeZone 函数
components.timeZone = TimeZone(abbreviation: "GMT")
var newDate1 = calendar.date(from: components)

//比较两个Date 对象 让我们先创建两个Date 对象



dateformatter.dateFormat = "MMM dd,yyyy"

var dateAsString = "Oct 01,2017"

var date1 = dateformatter.date(from: dateAsString)

var dateNSVersion = date1 as! NSDate

dateAsString = "Oct 02,2015"

var date2 = dateformatter.date(from: dateAsString)

//比较的第一种方式

//earlierDate和 laterDate 函数(这是NSDate 类中的方法,Date中并没有  所以只有强制转化为NSDate了)

//原理如下: return  date1 >= date2 ? date1 : date2

//判断date1 和 date2 的 ">=" 关系 是 返回date1, 否 返回date2
//两者原理一样

//举个栗子

dateNSVersion.earlierDate(date2!)
dateNSVersion.laterDate(date2!)

//比较的第二种方法
//使用的是compare方法以及 comparisonResult

//先举个栗子 date1 < date2  升序排列



if date1?.compare(date2!) == .orderedAscending
{
    print("<")
}
//相等的 date1 =  date2  相等

if date1?.compare(date2!) == .orderedSame
{
    print(" = ")
}
//降序排列的 date1 > date2  降序排列

if date1?.compare(date2!) == .orderedDescending
{
    print("<")
}

//第三种方法 timeInterval

//它做的就是获取每个日期以来的时间间隔


if  (date1?.timeIntervalSinceReferenceDate)! - (date2?.timeIntervalSinceReferenceDate)! >= 0{
    print("大于等于")
}
else{
    print("小于")
}



//计算未来或者过去的日期
//方法-: 一个一个改  使用默认的Calendar.Component
let monthsToAdd = 2

let daysToAdd = 10

var calculatedDate = Calendar.current.date(byAdding: Calendar.Component.month, value: monthsToAdd, to: currentdate)


calculatedDate = Calendar.current.date(byAdding: .day, value: daysToAdd, to: currentdate)

//如果你要加年月日,时分秒,很多的话  这样会很麻烦 就有了第二种方法
//方法二: 直接给定一个DateComponents对象,然后设置年月日等

var newDateComponent = DateComponents()
newDateComponent.month = monthsToAdd
newDateComponent.day = daysToAdd

calculatedDate = Calendar.current.date(byAdding: newDateComponent, to: currentdate)


//方法三:
//第三种计算另一个日期方式不推荐对时间跨度大的情况使用，因为由于闰秒，闰年，夏令时等等会导致这种方式产生出错误结果。该方式的想法是给当前日期加上一个特定的时间间隔。我们会使用 NSDate 类的 dateByAddingTimeInterval: 方法来实现这个目的。下面的例子中我们算出来一个相当于是 2 小时的时间间隔，然后把它加到当前日期上：

let hoursToAddInSeconds: TimeInterval = 120 * 60
calculatedDate = currentdate.addingTimeInterval(hoursToAddInSeconds)


//计算过去的时间
let numberOfDays = -360
calculatedDate = Calendar.current.date(byAdding: .day, value: numberOfDays, to: currentdate)


//计算时间的差值

//我们还是使用上面定义的两个Date

//为了清晰起见,我们先打印一下定义的两个Date
date1
date2



var diffDateComponents1 = Calendar.current.dateComponents([.year,.month,.day], from: date1!, to: date2!)


//方法二 : 使用时间间隔的方法
let dateComponentsFormatter = DateComponentsFormatter()
dateComponentsFormatter.unitsStyle = .full

//unitsStyle 属性告诉 dateComponentsFormatter 描述日期差值的那个字符串的格式应该是什么样的
let interval = date2?.timeIntervalSince(date1!)
dateComponentsFormatter.string(from: interval!)




//方法三:
dateComponentsFormatter.allowedUnits = [.year,.month,.day]

//如果你想知道他们之间差了多少天dateComponentsFormatter.allowedUnits = [.day]
let autoFormattedDifference = dateComponentsFormatter.string(from: date1!, to: date2!)








