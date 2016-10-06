#Date Operation
##前言
 最近在写关于日期的一些操作,所以整理了一下这方面的一些知识

本Demo使用的是playground.
> 我们以前使用的都是`NSDate`类进行日期的操作,在Swift 3.0中,我们就可以使用更加Swift化的 `Date` (这是一个结构体)

![Date](http://upload-images.jianshu.io/upload_images/2239937-342d069d482720c1.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

---
##Date的展示 


 我们知道`Date`是一个结构体.Date虽然包含了日期中的所有信息,它本身是不能显示在界面上的,这就得来依靠我们的`String`

---
####Date 和 String 的 转换
  1. 首先我们使用`Date `获取当前日期
              
          let currentdate = Date()

  2. 接下来初始化`DateFormatter` 用来在Date 和 String 之间相互转换

>关于`DateFormatter` ,从字面理解吧,这就是一个格式化的工具.你有了`Date`,你需要提供`Date`的展示方式,毕竟每个国家他的日期显示的格式都不大相同吧,这取决你自己的需求

    let dateformatter = DateFormatter()

 所以你在将 `Date` 转换为`String` 之前 你需要告诉`DateFormatter `你需要显示的字符串的结果的格式
//这里格式有5种 根据自己的需求去设置枚举值

        dateformatter.dateStyle = .full
        dateformatter.timeStyle = .long

3.你有了一个Date,也指定了一个DateFormatter的格式化的方法,接下来我们就可以来用String 来描述这个Date了

    let dateString = dateformatter.string(from: currentdate)

---
###自定义格式
当你觉得枚举值中输出的格式, 无法满足你的要求,你要自定义日期的输出格式的话.你需要格式化你的日期字符串,具体的请参考
http://unicode.org/reports/tr35/tr356.html#Date_Format_Patterns

>//EEEE:表示星期几(Monday),使用1-3个字母表示周几的缩写
//MMMM:月份的全写(October),使用1-3个字母表示月份的缩写
//dd:表示日期,使用一个字母表示没有前导0
//YYYY:四个数字的年份(2016)
//HH:两个数字表示的小时(02或21)
//mm:两个数字的分钟 (02或54)
//ss:两个数字的秒
//zzz:三个字母表示的时区

你现在已经有了一个格式化日期的`dateformatter`,既然枚举格式无法满足,你需要提供自己的格式给`dateformatter`(这是一个String 的字符串)

    dateformatter.dateFormat = " YYYY - MM - dd HH:mm:ss"
 然后还是使用DateFormatter的 `func string(from: Date)`方法
     
    let customDate = dateformatter.string(from: currentdate)

####把既定格式的字符串转化为Date

我们需要给定一个日期格式的字符串,接着指定格式化的方法,最后得到一个代表输入字符串的Date

    var string1 = "2016-10-05"
    dateformatter.dateFormat = " YYYY - MM - dd"
    var newDate = dateformatter.date(from: string1)

---
###"拆分"Date
很多时候你有一个Date,你可能只是需要它的day,month,hour 等的值

`DateComponents` 通常和 `Calendar` 结合起来使用. `Calendar` 实现了真正的从`Date` 到 `DateComponents`的转换以及从日期的组成元素到日期对象的转换.
 
>关于`DateComponents` 和 `Calendar`,我是这么认为的,你有了一个Date,要"拆分"Date,来找出自己需要的.可能是今天是几月几号,现在几点了这种类似的.我们的`DateComponents`就是你的同伙,帮着你把Date活生生的拆了.`Calendar`就是日历,它提供了日历的计算

首先我们获取现在的`calendar`
     
     let calendar = Calendar.current

简单的说就是用 `calendar`的`拆分工具`把`Date`拆了
     
    let dateComponents = calendar.dateComponents([.year,.month, .day, .hour,.minute,.second], from: currentdate )

这样你就可以拿到你需要的

###从 DateComponents 转化为 Date 

你可以把`Date`拆开,同样的,你也可以使用零件(day,month)把Date拼回去

装上去之前,我们先要拿到零件盒 `DateComponents`

    var components = DateComponents()
接着定制我们的零件
   
    components.year = 2016
    components.day = 10
    components.month = 11

你也可以设置时区 使用TimeZone 函数(使用时区的缩写)
 > 关于时区的缩写网址:http://www.icoa.cn/a/611.html
   
     components.timeZone = TimeZone(abbreviation: "GMT")

有了完整的零件,接着我们就可以拼出来Date了
    
     var newDate1 = calendar.date(from: components)

---
###Date的比较
我们经常需要比较两个Date ,在此之前 让我们先创建两个Date 
#### String -> Date

 我们可以设置自定义格式化的方法,通过用户的输入来将一个`String` 转化为一个` Date`

<strong>注:  需要注意的是你输入的格式,需要和格式化的时候的匹配</strong>
  

    dateformatter.dateFormat = "MMM dd,yyyy"

    var dateAsString = "Oct 01,2017"

    var date1 = dateformatter.date(from: dateAsString)

    var dateNSVersion = date1 as! NSDate

    dateAsString = "Oct 02,2015"

    var date2 = dateformatter.date(from: dateAsString)

>关于上面的为什么需要`NSDate`,下面会说到

####比较的第一种方式

earlierDate和 laterDate 函数(这是NSDate 类中的方法,Date中并没有 ,所以只有强制转化为NSDate了)

原理如下: return  date1 >= date2 ? date1 : date2

判断date1 和 date2 的 ">=" 关系 是 返回date1, 否 返回date2
两者原理一样

举个栗子

    dateNSVersion.earlierDate(date2!)
    dateNSVersion.laterDate(date2!)


####比较的第二种方法
使用的是compare方法以及 comparisonResult(枚举类型,表示升序,降序,还是相等)

先举个栗子 date1 < date2  升序排列

  	if date1?.compare(date2!) == .orderedAscending
      {
      	print(" < ")
      }
相等的 date1 =  date2  相等

   
 	if date1?.compare(date2!) == .orderedSame
    {
    		print(" = ")
    }  


降序排列的 date1 > date2  降序排列

  	if date1?.compare(date2!) == .orderedDescending
    {
    		print(" < ")
    }



####第三种方法 timeInterval,使用的是时间间隔来比较

它做的就是获取每个日期以来的时间间隔
>关于timeIntervalSinceReferenceDate
![](http://upload-images.jianshu.io/upload_images/2239937-0f1b0bd4fa36ae39.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

	if  (date1?.timeIntervalSinceReferenceDate)! - (date2?.timeIntervalSinceReferenceDate)! >= 0
		{
		print("大于等于")
		
    	}
    	else
    	{
    		print("小于")
    	}

---
###计算未来或者过去的日期
####方法-: 一个一个改  使用默认的Calendar.Component

我们想让给月份加2,天数加10
   
     let monthsToAdd = 2
     let daysToAdd = 10
接下来我们先给月份加
    
    var calculatedDate = Calendar.current.date(byAdding: Calendar.Component.month, value: monthsToAdd, to: currentdate)

然后在这个基础上再给day加
    
    calculatedDate = Calendar.current.date(byAdding: .day, value: daysToAdd, to: currentdate)

如果你要加年月日,时分秒,很多的话  这样会很麻烦 就有了第二种方法
#### 方法二: 直接给定一个DateComponents对象,然后设置年月日等

我们还是拿到我们的零件盒`DateComponents`,接着拿上需要更换的零件(month,day)

    var newDateComponent = DateComponents()
    newDateComponent.month = monthsToAdd
    newDateComponent.day = daysToAdd
最后把零件盒里面的零件装到Date上(相比于第一种,把所有更改一次性完成)

    calculatedDate = Calendar.current.date(byAdding: newDateComponent, to: currentdate)

####方法三:时间间隔的方法TimeInterval
第三种计算另一个日期方式不推荐对时间跨度大的情况使用，因为由于闰秒，闰年，夏令时等等会导致这种方式产生出错误结果。该方式的想法是给当前日期加上一个特定的时间间隔。我们会使用 `Date `类的 `addingTimeInterval:` 方法来实现这个目的。下面的例子中我们算出来一个相当于是 2 小时的时间间隔，然后把它加到当前日期上：

let hoursToAddInSeconds: TimeInterval = 120 * 60
calculatedDate = currentdate.addingTimeInterval(hoursToAddInSeconds)



计算过去的时间  和计算未来的时间一样

    let numberOfDays = -360
    calculatedDate = Calendar.current.date(byAdding: .day, value: numberOfDays, to: currentdate)

###计算时间的差值

我们还是使用上面定义的两个Date

####方法一:
接着使用`Calendar`的`dateComponents:`方法来计算Date的差值,如果你的第一个Date 比第二个Date小,那么结果就是负数
var diffDateComponents1 = Calendar.current.dateComponents([.year,.month,.day], from: date1!, to: date2!)

####方法二 : 
使用时间间隔的方法,  `DateComponentsFormatter`你需要定制你的格式.你是需要所有的年月日,还是只需要年,或者月之类

    let dateComponentsFormatter = DateComponentsFormatter()
    dateComponentsFormatter.unitsStyle = .full
>unitsStyle
unitsStyle 属性告诉 dateComponentsFormatter 描述日期差值的那个字符串的格式应该是什么样的,关于枚举值:看文档吧,这里不赘述

    let interval = date2?.timeIntervalSince(date1!)
    dateComponentsFormatter.string(from: interval!)

###方法三:
我们把 `DateComponents`认为是零件盒,里面有month.day等的零件,而
`dateComponentsFormatter`也就是我们这个零件盒的格式.定制我们的零件盒格式`allowedUnits `,具体到这里就是说我们的零件盒里面只有年月日,所以比较完返回的格式就是年月日这种的.因为我们只有年月日,所以不会出现别的零件,像时分秒这种的
    
    dateComponentsFormatter.allowedUnits = [.year,.month,.day]

如果你想知道他们之家差了多少天. 就可以只在盒子里面放上天的零件,这样你得到的就是这两个Date相差多少天

    dateComponentsFormatter.allowedUnits = [.day]
    let autoFormattedDifference = dateComponentsFormatter.string(from: date1!, to: date2!)

---
##总结
 到这里就已经结束了,写了好久才完成.我并没有直接的给出所有的这些代码的运行结果,我希望大家可以去试试,只有动手去做才会记住.而且Swift为我们提供了一个很好的工具 playground.
这里有篇文章写的很好:http://www.jianshu.com/p/3e5f6cb1c31c
就是根据这篇文章才写出来这个小Demo,希望可以得到分享
希望可以帮到大家,如果你觉得还可以的话,请给颗星(*^__^*) 嘻嘻……
