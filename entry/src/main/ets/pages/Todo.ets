import { Const, ScheduleModel } from '../model/ScheduleModel'
import relationalStore from '@ohos.data.relationalStore'
import dbUtil from '../Util/DbUtil'
import observer from '@ohos.telephony.observer'
import thermal from '@ohos.thermal'
import {getScheduleList} from './Index'
import {getScheduleFinishList} from './Index'
import {getScheduleOutDatedList} from './Index'
import {getToDoList} from './Index'
import router from '@ohos.router'
@Component
export struct Todo {

  date:Date = new Date()

  @State currentYear:number = this.date.getFullYear()

  @State currentMonth:number = this.date.getMonth()+1

  @State currentDate:number = this.date.getDate()

  @State currentHour:number = this.date.getHours()

  @State currentMinute:number = this.date.getMinutes()

  @State rotateAngle:number = 0

  @State rotateAngle2:number = 0

  @State rotateAngle3:number = 0

  @State flag:boolean = true

  @State flag2:boolean = true

  @State flag3:boolean = true

  @Link ArrayFinish:ScheduleModel[]

  @Link ArrayOutDated:ScheduleModel[]

  @State refreshing:boolean = false

  @Link todoList:ScheduleModel[]

  scroller:Scroller = new Scroller()

  @Styles builder(){
    .backgroundColor('rgba(243, 243, 243, 0.6)')
    .backdropBlur(20)
    .shadow({
      color: 'rgba(0, 0, 0, 0.12)',
      radius: 30,
      offsetX: 1,
      offsetY: 1})}


  @Builder CustomBuilder(item:ScheduleModel) {
    Row() {
      Image($r('app.media.ic_public_ok_filled'))
        .size({ height: 20, width: 20 })
        .margin({ right: 10, left: 15 })
        .onClick(() => {
          AlertDialog.show(
            {
              message: '是否已完成？',
              autoCancel: true,
              alignment: DialogAlignment.Center,
              gridCount: 3,
              primaryButton: {
                value: '否',
                action: () => {
                }
              },
              secondaryButton: {
                value: '是',
                action: async () => {
                  item.IsFinish = 1
                  let num = await dbUtil.update('DATE', item, Const, item.id)

                  getToDoList().then((result:ScheduleModel[])=>{
                    this.todoList = result
                  }).catch((err:Error)=>{
                    console.log(err.toString())
                  })

                  getScheduleOutDatedList().then((result:ScheduleModel[])=>{
                    this.ArrayOutDated = result
                  }).catch((err:Error)=>{
                    console.log(err.toString())
                  })

                  getScheduleFinishList().then((result:ScheduleModel[])=>{
                    this.ArrayFinish = result
                  }).catch((err:Error)=>{
                    console.log(err.toString())
                  })
                }
              },
              cancel: () => {
                console.info('Closed callbacks')
              }
            })
        })
      Image($r('app.media.ic_public_delete'))
        .size({ height: 20, width: 20 })
        .margin({ right: 10 })
        .onClick(async () => {
          AlertDialog.show(
            {
              message: '是否确认删除？',
              autoCancel: true,
              alignment: DialogAlignment.Center,
              gridCount: 3,
              primaryButton: {
                value: '否',
                action: () => {
                  console.info('Callback when the first button is clicked')
                }
              },
              secondaryButton: {
                value: '是',
                action: async () => {
                  let predicates = new relationalStore.RdbPredicates("DATE");
                  predicates.equalTo('ID', item.id);
                  let num = await dbUtil.delete(predicates)

                  getToDoList().then((result:ScheduleModel[])=>{
                    this.todoList = result
                  }).catch((err:Error)=>{
                    console.log(err.toString())
                  })

                  getScheduleOutDatedList().then((result:ScheduleModel[])=>{
                    this.ArrayOutDated = result
                  }).catch((err:Error)=>{
                    console.log(err.toString())
                  })

                  getScheduleFinishList().then((result:ScheduleModel[])=>{
                    this.ArrayFinish = result
                  }).catch((err:Error)=>{
                    console.log(err.toString())
                  })
                }

              },
              cancel: () => {
                console.info('Closed callbacks')
              }
            })
        })
    }
  }

  @Builder CustomBuilder2(item:ScheduleModel) {
    Row() {
      Image($r('app.media.ic_public_delete'))
        .size({ height: 20, width: 20 })
        .margin({ left: 15 })
        .onClick(async () => {
          AlertDialog.show(
            {
              message: '是否确认删除？',
              autoCancel: true,
              alignment: DialogAlignment.Center,
              gridCount: 3,
              primaryButton: {
                value: '否',
                action: () => {
                  console.info('Callback when the first button is clicked')
                }
              },
              secondaryButton: {
                value: '是',
                action: async () => {
                  let predicates = new relationalStore.RdbPredicates("DATE");
                  predicates.equalTo('ID', item.id);
                  let num = await dbUtil.delete(predicates)

                  getToDoList().then((result:ScheduleModel[])=>{
                    this.todoList = result
                  }).catch((err:Error)=>{
                    console.log(err.toString())
                  })

                  getScheduleOutDatedList().then((result:ScheduleModel[])=>{
                    this.ArrayOutDated = result
                  }).catch((err:Error)=>{
                    console.log(err.toString())
                  })

                  getScheduleFinishList().then((result:ScheduleModel[])=>{
                    this.ArrayFinish = result
                  }).catch((err:Error)=>{
                    console.log(err.toString())
                  })
                }

              },
              cancel: () => {
                console.info('Closed callbacks')
              }
            })
        })
    }
  }

 build(){
    Scroll(this.scroller){
      Column(){
        Refresh({refreshing:$$this.refreshing})
        .onRefreshing(()=>{
          setTimeout(() => {
            getToDoList().then((result:ScheduleModel[])=>{
              this.todoList = result
            }).catch((err:Error)=>{
              console.log(err.toString())
            })

            getScheduleOutDatedList().then((result:ScheduleModel[])=>{
              this.ArrayOutDated = result
            }).catch((err:Error)=>{
              console.log(err.toString())
            })

            getScheduleFinishList().then((result:ScheduleModel[])=>{
              this.ArrayFinish = result
            }).catch((err:Error)=>{
              console.log(err.toString())
            })
            this.refreshing = false
          }, 500)
        })
        Row(){
          Text('待办')
            .fontSize(15)
            .margin({left:10})
          Blank()
          Image($r('app.media.ic_public_arrow_up_0'))
            .size({height:15,width:15})
            .rotate({angle:this.rotateAngle})
            .animation({
              duration: 500,
              curve: Curve.Friction,
              delay: 0,
              iterations: 1, // 设置-1表示动画无限循环
              playMode: PlayMode.Normal
            })
        }
        .onClick(()=>{
          this.rotateAngle = this.rotateAngle+180
          this.flag = !this.flag
        })
        .justifyContent(FlexAlign.Start)
        .width('95%')
        .height('7%')

        List(){
          ForEach(this.todoList,(item:ScheduleModel)=>{
            ListItem(){
              todoItem({item:item})
            }
            .swipeAction({end:this.CustomBuilder(item)})
            .onClick(()=>{
              router.pushUrl({url:'pages/ContentPage',params:{item:item}},router.RouterMode.Single)
            })
          })
        }
        .alignListItem(ListItemAlign.Center)
        .visibility(this.flag == true?Visibility.Visible:Visibility.None)

        Divider()

        Row(){
          Text('已完成')
            .fontSize(15)
            .margin({left:10})
          Blank()
          Image($r('app.media.ic_public_arrow_up_0'))
            .size({height:15,width:15})
            .rotate({angle:this.rotateAngle2})
            .animation({
              duration: 500,
              curve: Curve.Friction,
              delay: 0,
              iterations: 1, // 设置-1表示动画无限循环
              playMode: PlayMode.Normal
            })
        }
        .onClick(()=>{
          this.rotateAngle2 = this.rotateAngle2+180
          this.flag2 = !this.flag2
        })
        .justifyContent(FlexAlign.Start)
        .width('95%')
        .height('7%')


        List(){
          ForEach(this.ArrayFinish,(item:ScheduleModel)=>{
            ListItem(){
              todoItem({item:item})
            }
            .swipeAction({end:this.CustomBuilder2(item)})
            .onClick(()=>{
              router.pushUrl({url:'pages/ContentPage',params:{item:item}},router.RouterMode.Single)
            })
          })
        }
        .alignListItem(ListItemAlign.Center)
        .visibility(this.flag2 == true?Visibility.Visible:Visibility.None)

        Divider()

        Row(){
          Text('已过期')
            .fontSize(15)
            .margin({left:10})
          Blank()
          Image($r('app.media.ic_public_arrow_up_0'))
            .size({height:15,width:15})
            .rotate({angle:this.rotateAngle3})
            .animation({
              duration: 500,
              curve: Curve.Friction,
              delay: 0,
              iterations: 1, // 设置-1表示动画无限循环
              playMode: PlayMode.Normal
            })
        }
        .onClick(()=>{
          this.rotateAngle3 = this.rotateAngle3+180
          this.flag3 = !this.flag3
        })
        .justifyContent(FlexAlign.Start)
        .width('95%')
        .height('7%')

        List(){
          ForEach(this.ArrayOutDated,(item:ScheduleModel)=>{
            ListItem(){
              todoItem({item:item})
            }
            .swipeAction({end:this.CustomBuilder2(item)})
            .onClick(()=>{
              router.pushUrl({url:'pages/ContentPage',params:{item:item}},router.RouterMode.Single)
            })
          })
        }
        .alignListItem(ListItemAlign.Center)
        .visibility(this.flag3 == true?Visibility.Visible:Visibility.None)
      }
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
   }
}

@Component
struct todoItem{

  @ObjectLink item:ScheduleModel

  @Styles builder(){
    .backgroundColor('rgba(243, 243, 243, 0.6)')
    .backdropBlur(20)
    .shadow({
      color: 'rgba(0, 0, 0, 0.12)',
      radius: 30,
      offsetX: 1,
      offsetY: 1})}


  build(){
    Row() {
      Divider()
        .vertical(true)
        .color('#0091FF')
        .height('70%')
        .strokeWidth(4)
        .lineCap(LineCapStyle.Round)
        .margin({ left: 10, right: 10 })
      Text(this.item.Title)
        .fontSize(25)

    }
    .borderRadius(15)
    .builder()
    .justifyContent(FlexAlign.Start)
    .height('7%')
    .width('95%')
  }
}