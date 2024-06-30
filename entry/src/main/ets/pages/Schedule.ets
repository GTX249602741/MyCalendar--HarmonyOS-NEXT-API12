import {Solar} from 'lunar';
import {DateClass} from '../DateClass'
import {swiperClass} from '../swiperClass'
import {YearPicker} from './YearPicker'
@Entry
@Component
export struct Schedule {
  @State currentYear : number = 0

  @State currentSwiperIndex : number = 0

  @State currentMonth : number = 0

  @State nextMonth : number = 0

  @State lastMonth : number = 0

  //当前月的第一天是星期几
  @State currentFirstDateOfWeekDay : number = 0
  //上个月的最大天数
  @State lastMonthDays : number = 0
  //当前月最后一天是星期几
  @State lastDateOfWeek : number = 0
  //当前月最大天数
  @State currentMonthDays : number = 0
  //当前页面中下个月的日期
  @State nextMonthDateOfWeek : number = 0

  @State flag : boolean = true

  @State lastMonthPageArray :DateClass[] = []

  @State nextMonthPageArray :DateClass[] = []

  @State swiperArray: DateClass[][] = []

  private swiperController: SwiperController = new SwiperController()
  //在当前页面显示的所有日期
  @State currentPageArray : DateClass[] = []

  private week : string[] = ['一','二','三','四','五','六','日']


  private dialogController: CustomDialogController = new CustomDialogController({
    builder:YearPicker({currentYear:$currentYear,flag:$flag}),
    alignment:DialogAlignment.Top,
    offset: { dx: -20, dy: 40},
    customStyle:true
    }
  )

  aboutToAppear(){
    let date = new Date()
    this.currentYear = date.getFullYear()
    this.currentMonth = date.getMonth()+1
    this.nextMonth = this.currentMonth+1
    this.lastMonth = this.currentMonth-1
    this.lastMonthPageArray = this.getCalendar(this.currentYear,this.lastMonth)
    this.swiperArray.push(this.lastMonthPageArray)
    let pageArray = this.getCalendar(this.currentYear,this.currentMonth)
    this.swiperArray.push(pageArray)
    this.nextMonthPageArray = this.getCalendar(this.currentYear,this.nextMonth)
    this.swiperArray.push(this.nextMonthPageArray)


    /**for (let i = 1; i < 12; i++) {
      let pageArray = this.getCalendar(this.currentYear,i)
      this.swiperArray.push(pageArray)
    }
     **/

    //this.lastMonthPageArray = this.getCalendar(this.currentYear,this.lastMonth)

    //console.log('test',this.lastMonth.toString())
    //this.swiperArray.push(lastMonthPageArray)
    //this.currentPageArray = []
    //this.currentPageArray = this.getCalendar(this.currentYear,this.currentMonth)

    //this.swiperArray.push(this.currentPageArray)
    //this.currentPageArray = []
    //this.nextMonthPageArray = this.getCalendar(this.currentYear,this.nextMonth)
    //this.swiperArray.push(nextMonthPageArray)
    //this.currentPageArray = []
  }

  getCalendar(Year:number,Month:number):DateClass[]{
    let PageArray = []
    this.currentFirstDateOfWeekDay =new Date(Year,Month-1,1).getDay()
    this.lastMonthDays = new Date(Year,Month-1,0).getDate()
    this.currentMonthDays = new Date(Year,Month,0).getDate()
    this.lastDateOfWeek = new Date(Year,Month,0).getDay()
    if(this.lastDateOfWeek===0){
      this.lastDateOfWeek = 7
    }
    this.nextMonthDateOfWeek = new Date(Year,Month,1).getDay()

    for (let i = this.lastMonthDays-this.currentFirstDateOfWeekDay+2; i <=this.lastMonthDays ; i++) {
      //let date : Date = new Date()
      let date1: Date = new Date(Year,Month-2,i)
      let solar = Solar.fromDate(date1);
      let lunarDay:string = solar.getLunar().toString().slice(5)
      PageArray.push(new DateClass(i,lunarDay))
    }
    for (let i = 1; i<=this.currentMonthDays; i++) {
      //let date : Date = new Date()
      let date1: Date = new Date(Year,Month-1,i)
      let solar = Solar.fromDate(date1);
      let lunarDay:string = solar.getLunar().toString().slice(5)
      PageArray.push(new DateClass(i,lunarDay))
    }
    for (let i = 1; i <=7-this.lastDateOfWeek; i++) {
      //let date : Date = new Date()
      let date1: Date = new Date(Year,Month,i)
      let solar = Solar.fromDate(date1);
      let lunarDay:string = solar.getLunar().toString().slice(5)
      PageArray.push(new DateClass(i,lunarDay))
    }
    return PageArray
  }
  build() {
    Column(){
      Row(){
        Text(this.currentYear.toString()+'年')
          .fontSize(25)
          .fontFamily('harmonyOS_medium')
          .margin({left:10})
        Image(this.flag === true? $r('app.media.ic_public_arrow_down_0'):$r('app.media.ic_public_arrow_up_0'))
          .size({height:20,width:20})
          .margin({top:10})
          .onClick(()=>{
            if (this.flag === true) {
              this.dialogController.open()
            }
            if (this.flag === false) {
              this.dialogController.close()
            }

          })
        Text(+this.currentMonth.toString()+'月')
          .fontSize(25)
          .fontFamily('harmonyOS_medium')
        Blank()
        Image($r('app.media.ic_public_search'))
          .size({height:30,width:30})
          .margin({right:10})
      }.height('5%')
      .width('100%')
     /** TextPicker({ range: this.years, selected: this.currentYear-1990 })
        .backgroundColor(Color.Gray)
        .borderRadius('20')
        .height('20%')
        .width('30%')
        .onChange((value: string, index: number)=>{
          this.currentYear = parseInt(value)
        })
        .onAccept( (value: string, index: number) => {
          this.currentYear = parseInt(value)
        })
        .onCancel(()=>{
          this.flag = !this.flag
        })
      **/
      Row(){
        ForEach(this.week,(item:string)=>{
          Text(item)
            .fontFamily('harmonyOS_medium')
            .margin({top:10})
        })
      }.justifyContent(FlexAlign.SpaceAround)
      .width('100%')
      .height('7%')
      .borderRadius({topLeft:25,topRight:25})
      Divider()
      .color(Color.Black)
      Swiper(this.swiperController){
       ForEach(this.swiperArray,(item:DateClass[])=>{
          Grid() {
            ForEach(item, (item1: DateClass) => {
              GridItem() {
                Column() {
                  Text(item1.datenumber.toString())
                  Text(item1.lunarDay)
                    .fontSize(8)
                    .margin({ top: 5 })
                }
              }.margin({ top: 10 })
            })
          }
          .width('100%')
          .columnsTemplate('1fr 1fr 1fr 1fr 1fr 1fr 1fr')
          .height('35%')
          .borderRadius({bottomLeft:25,bottomRight:25})
        })
      }
      .cachedCount(2)
      .index(this.currentSwiperIndex)
      .curve(Curve.Smooth)
      .loop(false)
      .indicator(false)
      /**.onAnimationStart((index:number)=>{
        if (index===0) {
          this.currentMonth++
          this.currentPageArray = []
          this.currentPageArray = this.getCalendar(this.currentYear,this.currentMonth)
          index++
          this.currentSwiperIndex = index
          console.log('test',this.currentPageArray.length.toString())
        }
      })**/
      .onChange((index:number)=>{

        if (index===this.swiperArray.length-1) {
          this.currentMonth = this.nextMonth
          this.nextMonth++
          let pageArray = this.getCalendar(this.currentYear,this.nextMonth)
          this.swiperArray.push(pageArray)
          index = this.swiperArray.length-2
        }

        if (index===0) {
          this.currentMonth = this.lastMonth
          this.lastMonth--
          let pageArray = this.getCalendar(this.currentYear,this.lastMonth)
          this.swiperArray.unshift(pageArray)
          index = 0

        }
        this.currentSwiperIndex = index
      })
    }.width('100%')
    .height('100%')
  }
}