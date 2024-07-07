import thermal from '@ohos.thermal'

@Component
@CustomDialog
export  struct DatePickerDialogPage2 {

  date:Date = new Date()

  @Link selectedStartYear:number|undefined

  @Link selectedStartMonth:number|undefined

  @Link selectedStartDate:number|undefined

  @Link selectedStartHour:number|undefined

  @Link selectedStartMinute:number|undefined

  @Link selectedEndYear:number|undefined

  @Link selectedEndMonth:number|undefined

  @Link selectedEndDate:number|undefined

  @Link selectedEndHour:number|undefined

  @Link selectedEndMinute:number|undefined

  @Link fullDayFlag:boolean|undefined

  @Link selectedYear2:number|undefined

  @Link selectedMonth2:number|undefined

  @Link selectedDate2:number|undefined

  @Link selectedHour2:number|undefined

  @Link selectedMinute2:number|undefined

  @Link day2:string
 /** @Link selectedHour:number

  @Link selectedMinute:number

  @Link day1:string

  @Link selectedYear:number

  @Link selectedMonth:number

  @Link selectedDate:number
**/

  controller:CustomDialogController

  getDay(date:number):string{
    switch (date){
      case 1:
        return '一';
      case 2:
        return '二';
      case 3:
        return '三';
      case 4:
        return '四';
      case 5:
        return '五';
      case 6:
        return '六';
      case 0:
        return '日';

    }
    return ''
  }


  build() {
    Column(){
      Text(this.selectedYear2!.toString()+'年'+this.selectedMonth2!.toString()+'月'+this.selectedDate2!.toString()+'日星期'+this.day2!)
        //(this.selectedYear < this.selectedEndYear?this.selectedEndYear.toString():this.selectedYear.toString())+'年'+(this.selectedMonth < this.selectedEndMonth?(this.selectedEndMonth).toString():(this.selectedMonth).toString()) +'月'+(this.selectedDate < this.selectedEndDate?this.selectedEndDate.toString():this.selectedDate.toString())+'日星期'+
     // this.getDay(new Date(this.selectedYear < this.selectedEndYear?this.selectedEndYear:this.selectedYear,this.selectedMonth-1 < this.selectedEndMonth-1?(this.selectedEndMonth-1):(this.selectedMonth-1),this.selectedDate < this.selectedEndDate?this.selectedEndDate:this.selectedDate).getDay())
        .fontSize(20)
        .height('10%')
      Row() {
        DatePicker({
          start: new Date('1970-1-1'),
          end: new Date('2100-1-1'),
          selected:new Date(this.selectedEndYear,this.selectedEndMonth!-1,this.selectedEndDate)
           //new Date(this.selectedYear < this.selectedEndYear?this.selectedEndYear:this.selectedYear,this.selectedMonth-1 < this.selectedEndMonth-1?this.selectedEndMonth-1:this.selectedMonth-1,this.selectedDate < this.selectedEndDate?this.selectedEndDate:this.selectedDate)
        })
          .width(this.fullDayFlag == false? '60%':'100%')
          .height('40%')
          .onChange((value: DatePickerResult) => {
            let date = new Date(value.year! as number,value.month! as number,value.day! as number)
            this.day2 = this.getDay(date.getDay())
            this.selectedYear2 = value.year!
            this.selectedMonth2 = (value.month)!+1
            this.selectedDate2 = value.day!

            if (value?.year == this.selectedStartYear) {
              if ((value.month)!+1 == this.selectedStartMonth) {
                if (value.day! >= this.selectedStartDate!) {
                  this.selectedEndYear = value.year!
                  this.selectedEndMonth = (value.month)!+1
                  this.selectedEndDate = value.day!
                }
                else if (value.day! < this.selectedStartDate!){
                  this.selectedEndYear = value.year!
                  this.selectedEndMonth = (value.month)!+1
                  this.selectedEndDate = this.selectedStartDate
                }
              }
              else if ((value.month)!+1 > this.selectedStartMonth!) {
                  this.selectedEndYear = value?.year
                  this.selectedEndMonth = (value.month)!+1
                  this.selectedEndDate = value?.day
              }
              else if ((value.month)!+1 < this.selectedStartMonth!){
                this.selectedEndYear = value?.year
                this.selectedEndMonth = this.selectedStartMonth
                this.selectedEndDate = this.selectedStartDate
              }
            }else if (value.year! < this.selectedStartYear!){
              this.selectedEndYear = this.selectedStartYear
              this.selectedEndMonth = this.selectedStartMonth
              this.selectedEndDate = this.selectedStartDate
            }
            else if (value.year! > this.selectedStartYear!){
              this.selectedEndYear = value.year!
              this.selectedEndMonth = (value.month)!+1
              this.selectedEndDate = value.day!
            }


          })
        TimePicker({
          selected:new Date(this.selectedYear2,this.selectedMonth2!-1,this.selectedDate2,this.selectedHour2,this.selectedMinute2)
          // new Date(this.selectedYear < this.selectedEndYear?this.selectedEndYear:this.selectedYear,this.selectedMonth-1 < this.selectedEndMonth-1?this.selectedEndMonth-1:this.selectedMonth-1,
             // this.selectedDate < this.selectedEndDate?this.selectedEndDate:this.selectedDate,this.selectedHour < this.selectedEndHour?this.selectedEndHour:this.selectedHour,this.selectedMinute < this.selectedEndMinute?this.selectedEndMinute:this.selectedMinute)
        })
          .visibility(this.fullDayFlag == false? Visibility.Visible:Visibility.None)
          .width('20%')
          .height('40%')
          .useMilitaryTime(true)
          .onChange((value: TimePickerResult) => {
            this.selectedHour2 = value?.hour
            this.selectedMinute2 = value?.minute

            if (this.selectedYear2! >= this.selectedStartYear!) {
              if (this.selectedMonth2 == this.selectedStartMonth) {
                if (this.selectedDate2 == this.selectedStartDate) {
                  if (this.selectedHour2 == this.selectedStartHour) {
                    if (this.selectedMinute2 >= this.selectedStartMinute!) {
                      this.selectedEndYear = this.selectedYear2
                      this.selectedEndMonth = this.selectedMonth2
                      this.selectedEndDate = this.selectedDate2
                      this.selectedEndHour = this.selectedHour2
                      this.selectedEndMinute = this.selectedMinute2
                    }
                    else if (this.selectedMinute2 < this.selectedStartMinute!){
                      this.selectedEndYear = this.selectedYear2
                      this.selectedEndMonth = this.selectedMonth2
                      this.selectedEndDate = this.selectedDate2
                      this.selectedEndHour = this.selectedHour2
                      this.selectedEndMinute = this.selectedStartMinute
                    }
                  }
                  else if (this.selectedHour2 > this.selectedStartHour!) {

                      this.selectedEndYear = this.selectedYear2
                      this.selectedEndMonth = this.selectedMonth2
                      this.selectedEndDate = this.selectedDate2
                      this.selectedEndHour = this.selectedHour2
                      this.selectedEndMinute = this.selectedMinute2

                  }
                  else if (this.selectedHour2 < this.selectedStartHour!){
                    this.selectedEndYear = this.selectedYear2
                    this.selectedEndMonth = this.selectedMonth2
                    this.selectedEndDate = this.selectedDate2
                    this.selectedEndHour = this.selectedStartHour
                    this.selectedEndMinute = this.selectedStartMinute
                  }
                }
                else if (this.selectedDate2! < this.selectedStartDate!){
                  this.selectedEndYear = this.selectedYear2
                  this.selectedEndMonth = this.selectedMonth2
                  this.selectedEndDate = this.selectedStartDate
                  this.selectedEndHour = this.selectedStartHour
                  this.selectedEndMinute = this.selectedStartMinute
                }
                else if (this.selectedDate2! > this.selectedStartDate!){
                  this.selectedEndYear = this.selectedYear2
                  this.selectedEndMonth = this.selectedMonth2
                  this.selectedEndDate = this.selectedDate2
                  this.selectedEndHour = this.selectedHour2
                  this.selectedEndMinute = this.selectedMinute2
                }
              }
              else if (this.selectedMonth2! < this.selectedStartMonth!){
                this.selectedEndYear = this.selectedYear2
                this.selectedEndMonth = this.selectedStartMonth
                this.selectedEndDate = this.selectedStartDate
                this.selectedEndHour = this.selectedStartHour
                this.selectedEndMinute = this.selectedStartMinute
              }
              else if (this.selectedMonth2! > this.selectedStartMonth!){
                this.selectedEndYear = this.selectedYear2
                this.selectedEndMonth = this.selectedMonth2
                this.selectedEndDate = this.selectedDate2
                this.selectedEndHour = this.selectedHour2
                this.selectedEndMinute = this.selectedMinute2
              }
            }else if (this.selectedYear2! < this.selectedStartYear!){
              this.selectedEndYear = this.selectedStartYear
              this.selectedEndMonth = this.selectedStartMonth
              this.selectedEndDate = this.selectedStartDate
              this.selectedEndHour = this.selectedStartHour
              this.selectedEndMinute = this.selectedStartMinute
            }
            else if (this.selectedYear2! > this.selectedStartYear!){
              this.selectedEndYear = this.selectedYear2
              this.selectedEndMonth = this.selectedMonth2
              this.selectedEndDate = this.selectedDate2
              this.selectedEndHour = this.selectedHour2
              this.selectedEndMinute = this.selectedMinute2
            }

          })
      }
    }
  }
}