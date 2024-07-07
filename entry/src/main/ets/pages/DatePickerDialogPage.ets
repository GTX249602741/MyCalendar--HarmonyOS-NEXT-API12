import thermal from '@ohos.thermal'

@Component
@CustomDialog
export  struct DatePickerDialogPage {

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

  @Link selectedHour:number|undefined

  @Link selectedMinute:number|undefined

  @Link day1:string|undefined

  @Link selectedYear:number|undefined

  @Link selectedMonth:number|undefined

  @Link selectedDate:number|undefined

  @Link fullDayFlag:boolean|undefined


  controller:CustomDialogController

  getDay(date:number):string{
    switch (date){
      case 0:
        return '日';
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
    }
    return ''
  }


  build() {
    Column(){
      Text(this.selectedYear!.toString()+'年'+this.selectedMonth!.toString()+'月'+this.selectedDate!.toString()+'日星期'+this.day1)
        //(this.selectedYear > this.selectedStartYear?this.selectedStartYear.toString():this.selectedYear.toString())+'年'+(this.selectedMonth > this.selectedStartMonth?(this.selectedStartMonth).toString():(this.selectedMonth).toString()) +'月'+(this.selectedDate > this.selectedStartDate?this.selectedStartDate.toString():this.selectedDate.toString())
     // +'日星期'+this.getDay(new Date(this.selectedYear > this.selectedStartYear?this.selectedStartYear:this.selectedYear,this.selectedMonth-1 > this.selectedStartMonth-1?(this.selectedStartMonth-1):(this.selectedMonth-1),this.selectedDate > this.selectedStartDate?this.selectedStartDate:this.selectedDate).getDay()))
        .fontSize(20)
        .height('10%')
      Row() {
        DatePicker({
          start: new Date('1970-1-1'),
          end: new Date('2100-1-1'),
          selected:new Date(this.selectedStartYear,this.selectedStartMonth!-1,this.selectedStartDate)
          // new Date(this.selectedYear > this.selectedStartYear?this.selectedStartYear:this.selectedYear,this.selectedMonth-1 > this.selectedStartMonth-1?this.selectedStartMonth-1:this.selectedMonth-1,
              //this.selectedDate > this.selectedStartDate?this.selectedStartDate:this.selectedDate)
        })
          .width(this.fullDayFlag == false? '60%':'100%')
          .height('40%')
          .onChange((value: DatePickerResult) => {

            this.selectedYear = value!.year
            this.selectedMonth = (value.month)!+1
            this.selectedDate = value!.day

            let date = new Date(value!.year as number,value!.month as number,value!.day as number)
            this.day1 = this.getDay(date.getDay())

            if (value.year! <=this.selectedEndYear!) {
              if ((value.month)!+1 <= this.selectedEndMonth!) {
                if (value.day! <= this.selectedEndDate!) {
                  this.selectedStartYear = value!.year
                  this.selectedStartMonth = (value.month)!+1
                  this.selectedStartDate = value!.day
                }
                else if (value.day! > this.selectedEndDate!){
                  this.selectedStartYear = value!.year
                  this.selectedStartMonth = (value.month)!+1
                  this.selectedStartDate = value!.day
                  this.selectedEndDate = value!.day
                }
              }else if ((value.month)!+1 > this.selectedEndMonth!){
                this.selectedStartYear = value!.year
                this.selectedStartMonth = (value.month)!+1
                this.selectedStartDate = value!.day
                this.selectedEndDate = value!.day
                this.selectedEndMonth = (value.month)!+1
              }
            }else if (value.year! > this.selectedEndYear!){
              this.selectedStartYear = value!.year
              this.selectedStartMonth = (value.month)!+1
              this.selectedStartDate = value!.day
              this.selectedEndDate = value!.day
              this.selectedEndMonth = (value.month)!+1
              this.selectedEndYear = value!.year
            }
          })
        TimePicker({
          selected:new Date(this.selectedYear!,this.selectedMonth!-1,this.selectedDate!,this.selectedHour!,this.selectedMinute!)
          //new Date(this.selectedYear > this.selectedStartYear?this.selectedStartYear:this.selectedYear,this.selectedMonth-1 > this.selectedStartMonth-1?this.selectedStartMonth-1:this.selectedMonth-1,
              //this.selectedDate > this.selectedStartDate?this.selectedStartDate:this.selectedDate,this.selectedHour > this.selectedStartHour?this.selectedStartHour:this.selectedHour,this.selectedMinute > this.selectedStartMinute?
            //this.selectedStartMinute:this.selectedMinute)
        })
          .visibility(this.fullDayFlag == false? Visibility.Visible:Visibility.None)
          .width('20%')
          .height('40%')
          .useMilitaryTime(true)
          .onChange((value: TimePickerResult) => {
            this.selectedHour = value!.hour
            this.selectedMinute = value!.minute

            if (this.selectedYear! <=this.selectedEndYear!) {
              if (this.selectedMonth! <= this.selectedEndMonth!) {
                if (this.selectedDate! <= this.selectedEndDate!) {
                  if (this.selectedHour <= this.selectedEndHour!) {
                    if (this.selectedMinute <= this.selectedEndMinute!) {
                      this.selectedStartYear = this.selectedYear
                      this.selectedStartMonth = this.selectedMonth
                      this.selectedStartDate = this.selectedDate
                      this.selectedStartHour = value!.hour
                      this.selectedStartMinute = value!.minute
                    }
                    else if (this.selectedMinute > this.selectedEndMinute!){
                      this.selectedStartYear = this.selectedYear
                      this.selectedStartMonth = this.selectedMonth
                      this.selectedStartDate = this.selectedDate
                      this.selectedStartHour = value!.hour
                      this.selectedStartMinute = value!.minute
                      this.selectedEndMinute = value!.minute
                    }
                  }else if (this.selectedHour > this.selectedEndHour!){
                    this.selectedStartYear = this.selectedYear
                    this.selectedStartMonth = this.selectedMonth
                    this.selectedStartDate = this.selectedDate
                    this.selectedStartHour = value!.hour
                    this.selectedStartMinute = value!.minute
                    this.selectedEndMinute = value!.minute
                    this.selectedEndHour = value!.hour
                  }
                }
                else if (this.selectedDate! > this.selectedEndDate!){
                  this.selectedStartYear = this.selectedYear
                  this.selectedStartMonth = this.selectedMonth
                  this.selectedStartDate = this.selectedDate
                  this.selectedEndDate = this.selectedDate
                  this.selectedStartHour = value!.hour
                  this.selectedStartMinute = value!.minute
                  this.selectedEndMinute = value!.minute
                  this.selectedEndHour = value!.hour
                }
              }else if (this.selectedMonth! > this.selectedEndMonth!){
                this.selectedStartYear = this.selectedYear
                this.selectedStartMonth = this.selectedMonth
                this.selectedStartDate = this.selectedDate
                this.selectedEndDate = this.selectedDate
                this.selectedEndMonth = this.selectedMonth
                this.selectedStartHour = value!.hour
                this.selectedStartMinute = value!.minute
                this.selectedEndMinute = value!.minute
                this.selectedEndHour = value!.hour
              }
            }else if (this.selectedYear! > this.selectedEndYear!){
              this.selectedStartYear = this.selectedYear
              this.selectedStartMonth = this.selectedMonth
              this.selectedStartDate = this.selectedDate
              this.selectedEndDate = this.selectedDate
              this.selectedEndMonth = this.selectedMonth
              this.selectedEndYear = this.selectedYear
              this.selectedStartHour = value!.hour
              this.selectedStartMinute = value!.minute
              this.selectedEndMinute = value!.minute
              this.selectedEndHour = value!.hour
            }

            console.info('select current date is: ' + JSON.stringify(value))
          })
      }
    }
  }
}