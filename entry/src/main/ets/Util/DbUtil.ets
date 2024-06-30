import common from '@ohos.app.ability.common';
import relationalStore from '@ohos.data.relationalStore';
import { ColumnInfo, ColumnType } from './ColumnInfo';
import Logger from './Logger';
import { ScheduleModel } from '../model/ScheduleModel'

const DB_FILENAME: string = 'Date.db'

export class DbUtil {
  rdbStore: relationalStore.RdbStore | undefined

  initDB(context: common.UIAbilityContext): Promise<void> {
    let config: relationalStore.StoreConfig = {
      name: DB_FILENAME,
      securityLevel: relationalStore.SecurityLevel.S1
    }
    return new Promise<void>((resolve, reject) => {
      relationalStore.getRdbStore(context, config)
        .then(rdbStore => {
          this.rdbStore = rdbStore
          Logger.debug('rdbStore 初始化完成！')
          resolve()
        })
        .catch((reason:Error) => {
          Logger.debug('rdbStore 初始化异常', JSON.stringify(reason))
          reject(reason)
        })
    })
  }

  createTable(createSQL: string): Promise<void> {
    return new Promise((resolve, reject) => {
      this.rdbStore!.executeSql(createSQL)
        .then(() => {
          Logger.debug('创建表成功', createSQL)
          resolve()
        })
        .catch((err:Error) => {
          Logger.error('创建表失败,' + err.message, JSON.stringify(err))
          reject(err)
        })
    })
  }

  update(tableName:string, obj: ScheduleModel, columns: ColumnInfo[],id:number): Promise<number> {
    return new Promise((resolve, reject) => {
      // 1.构建更新数据
      let value = this.buildValueBucket(obj, columns)

      let  predicates = new relationalStore.RdbPredicates(tableName);

      predicates.equalTo('ID',id)
      // 2.更新
      this.rdbStore!.update( value, predicates,(err, id) => {
        if (err) {
          Logger.error('test5','更新失败！', JSON.stringify(err))
          reject(err)
        } else {
          Logger.debug('test5','更新成功！更新id：', id.toString())
          resolve(id)
        }
      })!
    })
  }

  insert(tableName: string, obj: ScheduleModel, columns: ColumnInfo[]): Promise<number> {
    return new Promise((resolve, reject) => {
      // 1.构建新增数据
      let value = this.buildValueBucket(obj, columns)
      // 2.新增
      this.rdbStore!.insert(tableName, value, (err, id) => {
        if (err) {
          Logger.error('新增失败！', JSON.stringify(err))
          reject(err)
        } else {
          Logger.debug('新增成功！新增id：', id.toString())
          resolve(id)
        }
      })!
    })
  }

  delete(predicates: relationalStore.RdbPredicates): Promise<number> {
    return new Promise((resolve, reject) => {
      this.rdbStore!.delete(predicates, (err, rows) => {
        if (err) {
          Logger.error('删除失败！', JSON.stringify(err))
          reject(err)
        } else {
          Logger.debug('删除成功！删除行数：', rows.toString())
          resolve(rows)
        }
      })!
    })
  }

  queryForList(predicates: relationalStore.RdbPredicates, columns: ColumnInfo[]): Promise<ScheduleModel[]> {
    return new Promise((resolve, reject) => {
      this.rdbStore!.query(predicates, columns.map(info => info.columnName), (err, result) => {
        if (err) {
          Logger.error('查询失败！', JSON.stringify(err))
          reject(err)
        } else {
          Logger.debug('查询成功！查询行数：', result.rowCount.toString())
          resolve(this.parseResultSet(result, columns))
        }
      })
    })
  }

  parseResultSet (result: relationalStore.ResultSet, columns: ColumnInfo[]): ScheduleModel[] {
    // 1.声明最终返回的结果
    let arr :ScheduleModel[]= []
    // 2.判断是否有结果
    if (result.rowCount <= 0) {
      return arr
    }
    // 3.处理结果
    while (!result.isAtLastRow) {
      // 3.1.去下一行
      result.goToNextRow()
      // 3.2.解析这行数据，转为对象
      let obj:Record<string,string | number | null> = {}
      columns.forEach(info => {
        let val :string |number |null= null

        switch (info.type) {
          case ColumnType.INTEGER:
            val = result.getLong(result.getColumnIndex(info.columnName))
            break
          case ColumnType.STRING:
            val = result.getString(result.getColumnIndex(info.columnName))
            break

        }
        obj[info.name]= val

      })
      // 3.3.将对象填入结果数组
      let objstring:string = JSON.stringify(obj)
      let obj1 = JSON.parse(objstring) as ScheduleModel
      arr.push(obj1)
      Logger.debug('查询到数据：', JSON.stringify(obj))
    }
    return arr
  }

  buildValueBucket(obj: ScheduleModel, columns: ColumnInfo[]): relationalStore.ValuesBucket {
    let objstring = JSON.stringify(obj)
    let obj1 = JSON.parse(objstring) as Record<string,string | number>

    let value:Record<string,string | number> = {}
    columns.forEach(info => {
      let val:string | number = obj1[info.name]
      if (typeof val !== 'undefined') {
        value[info.columnName] = val
      }
    })

    return value
  }
}


let dbUtil: DbUtil = new DbUtil();

export default dbUtil as DbUtil