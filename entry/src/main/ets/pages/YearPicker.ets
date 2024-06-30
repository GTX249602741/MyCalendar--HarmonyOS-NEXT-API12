import {Schedule} from './Schedule'
@CustomDialog
export  struct YearPicker {
  controller:CustomDialogController
  @Link currentYear : number
  @Link flag : boolean
  private years: string[] = []


aboutToAppear(){
    for (let index = 1990; index < 2090; index++) {
      this.years.push(index.toString())
    }
    return this.years
  }

  build() {
    Column() {
      TextPicker({ range: this.years, selected: this.currentYear-1990 })
        .height(150)
        .width(100)
        .borderRadius(50)
        .onChange((value: string, index: number)=>{
          this.currentYear = parseInt(value)
        })
      Button('确认')
        .onClick(()=>{
          this.flag = true
          this.controller.close()
        })
        .fontColor(Color.Black)
        .backgroundColor(Color.White)
        .fontSize(15)
    }
    .backgroundColor(Color.White)
    .borderRadius(25)
    .width('40%')
    .height('25%')
  }
}