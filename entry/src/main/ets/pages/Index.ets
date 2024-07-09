import font from '@ohos.font';
import image from '@ohos.multimedia.image';
import { MyOneDayPage } from './MyOneDayPage';
import { YearPage } from './YearPage'
import router from '@ohos.router'
import relationalStore from '@ohos.data.relationalStore'
import dbUtil from '../Util/DbUtil'
import { Const, ScheduleModel } from '../model/ScheduleModel'
import thermal from '@ohos.thermal';
import { Todo } from './Todo'
import OpenHarmonyTestRunner from '../../../ohosTest/ets/testrunner/OpenHarmonyTestRunner';
// 查询待办日程列表
export async function getToDoList():Promise<ScheduleModel[]>{
  let list:ScheduleModel[] = []
  let predicates = new relationalStore.RdbPredicates("DATE");
  predicates.equalTo('IsFinish',0)
  let array = await dbUtil.queryForList(predicates,Const)
  let date = new Date()
  for(let i of array){
  let date1 = new Date(i.EndYear as number,i.EndMonth!-1,i.EndDate,i.HourEnd,i.MinuteEnd)
    if (date.getFullYear() < date1.getFullYear()) {
      list.push(i)
    }
    if (date.getFullYear() == date1.getFullYear()) {
      if (date.getMonth()+1 < date1.getMonth()+1) {
        list.push(i)
      }
      if (date.getMonth()+1 == date1.getMonth()+1) {
        if (date.getDate() < date1.getDate()) {
          list.push(i)
        }
        if (date.getDate() == date1.getDate()) {
          if (date.getHours() < date1.getHours()) {
            list.push(i)
          }
          if (date.getHours() == date1.getHours()) {
            if (date.getMinutes() < date1.getMinutes()) {
              list.push(i)
            }
          }
        }
      }
    }
}
return list
}
// 查询过期日程列表
export async function getScheduleOutDatedList():Promise<ScheduleModel[]>{
  let ArrayOutDated:ScheduleModel[] = []
  let date1 = new Date()
  let predicates = new relationalStore.RdbPredicates("DATE")
  predicates.isNotNull("Title")
  let array = await dbUtil.queryForList(predicates, Const)
  for(let i of array){
    let date = new Date(i.EndYear as number,i.EndMonth!-1,i.EndDate,i.HourEnd,i.MinuteEnd)

    if (date1.getFullYear() > date.getFullYear()) {
      ArrayOutDated.push(i)
    }
    if (date1.getFullYear() == date.getFullYear()) {
      if (date1.getMonth()+1 > date.getMonth()+1) {
        ArrayOutDated.push(i)
      }
      if (date1.getMonth()+1 == date.getMonth()+1) {
        if (date1.getDate() > date.getDate()) {
          ArrayOutDated.push(i)
        }
        if (date1.getDate() == date.getDate()) {
          if (date1.getHours() > date.getHours()) {
            ArrayOutDated.push(i)
          }
          if (date1.getHours() == date.getHours()) {
            if (date1.getMinutes() > date.getMinutes()) {
              ArrayOutDated.push(i)
            }
          }
        }
      }
    }
  }
  return ArrayOutDated
}

//查询指定日期日程列表
export async function getScheduleList(currentYear:number,currentMonth:number,currentDate:number,currentHour:number,currentMinute:number):Promise<ScheduleModel[]>{
  let scheduleModelArray:ScheduleModel[] = []
  let predicates = new relationalStore.RdbPredicates("DATE")
  predicates.isNotNull("Title")
  let array = await dbUtil.queryForList(predicates, Const)
  for (let i of array) {
    if (i.StartYear! <= currentYear && i.EndYear! >= currentYear) {
      if (i.StartMonth ==currentMonth && i.EndMonth == currentMonth) {
        if (i.StartDate! <= currentDate && i.EndDate! >= currentDate) {
          scheduleModelArray.push(i)
        }
      }
      if (i.StartMonth == currentMonth && i.EndMonth != currentMonth) {
        if (i.StartDate! <=  currentDate ) {
          scheduleModelArray.push(i)
        }
      }
      if (i.StartMonth! < currentMonth && i.EndMonth! > currentMonth) {
        scheduleModelArray.push(i)
      }
      if (i.EndMonth == currentMonth && i.StartMonth != currentMonth) {
        if (i.EndDate! >= currentDate) {
          scheduleModelArray.push(i)
        }
      }
    }
  }
  return scheduleModelArray
}
// 查询已完成日程列表
export async function  getScheduleFinishList():Promise<ScheduleModel[]>{
  let ArrayFinish:ScheduleModel[] = []
  let predicates = new relationalStore.RdbPredicates("DATE");
  predicates.equalTo('IsFinish',1);
  let array = await dbUtil.queryForList(predicates, Const)
  for(let i of array){
    ArrayFinish.push(i)
  }
return ArrayFinish
}

@Entry
@Component
export struct Index {

  date:Date = new Date()

  @StorageLink('currentYear') currentYear:number | undefined= 1

  @StorageLink('currentMonth') currentMonth:number = 1

  @State currentDate:number = this.date.getDate()

  @State currentHour:number = this.date.getHours()

  @State currentMinute:number = this.date.getMinutes()

  private controller:TabsController = new TabsController()

  @State img:string = ''

  @State currentIndex:number = 0

  @State hasCalendar:boolean = false

  @State scheduleModelArray:Array<ScheduleModel> = []

  @State ArrayFinish:ScheduleModel[] = []

  @State ArrayOutDated:ScheduleModel[] = []

  @State todoList:ScheduleModel[] = []

  @Builder TabBuilder(index:number,name:string,image:ResourceStr,imagefill:ResourceStr){
    Column(){
      Image(this.currentIndex === index? imagefill:image)
        .height(30)
        .margin({top:5})
      Text(name)
        .fontSize(10)
        .margin({top:5})
        .fontColor(this.currentIndex === index?'#0091FF':Color.Black)
    }.width('100%')
    .height('100%')
    .backgroundColor(Color.Transparent)
  }

  onPageShow(){
    let YearParam :number | undefined= AppStorage.get('currentYear')

    let MonthParam:number | undefined = AppStorage.get('currentMonth')

    this.currentYear = YearParam

    this.currentMonth = MonthParam as number

    let date:Date = new Date()

    this.currentDate = date.getDate()

    this.currentHour = date.getHours()

    this.currentMinute = date.getMinutes()

    getToDoList().then((result:ScheduleModel[])=>{
      this.todoList = result
    }).catch((err:Error)=>{
      console.log(err.toString())
    })

    getScheduleList(this.currentYear as number,this.currentMonth,this.currentDate,this.currentHour,this.currentMinute).then((result:ScheduleModel[])=>{
      this.scheduleModelArray = result
    }).catch((err:Error)=>{
      console.log(err.toString())
    })

    getScheduleFinishList().then((result:ScheduleModel[])=>{
      this.ArrayFinish = result
    }).catch((err:Error)=>{
      console.log(err.toString())
    })

    getScheduleOutDatedList().then((result:ScheduleModel[])=>{
      this.ArrayOutDated = result
    }).catch((err:Error)=>{
      console.log(err.toString())
    })


  }

  build() {
    Column(){
      Tabs({controller:this.controller,barPosition:BarPosition.End,index:this.currentIndex}){
        TabContent(){
          YearPage({currentYear:$currentYear})
        }.tabBar(this.TabBuilder(0,'日程',$r('app.media.ic_public_calendar'),$r('app.media.ic_public_calendar_filled')))

        TabContent(){
          MyOneDayPage({scheduleModelArray:$scheduleModelArray,currentYear:$currentYear,currentMonth:$currentMonth,currentDate:$currentDate,currentHour:$currentHour,currentMinute:$currentMinute})

        }.tabBar(this.TabBuilder(1,'我的一天',$r('app.media.rili'),$r('app.media.rili_fill')))

        TabContent(){
          Todo({ArrayFinish:$ArrayFinish,ArrayOutDated:$ArrayOutDated,todoList:$todoList})

        }.tabBar(this.TabBuilder(2,'待办',$r('app.media.ic_public_todo'),$r('app.media.ic_public_todo_filled')))
      }
      .onChange((index:number)=>{
        this.currentIndex = index
      } )
    }.height('100%')
    .width('100%')
    .backgroundColor($r('sys.color.ohos_id_color_background'))


  }
}