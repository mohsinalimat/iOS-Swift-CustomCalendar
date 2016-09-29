# iOS-Swift-CustomCalendar

This is a simple (and easy to customize) Custom Calendar written in swift. 

## Features

* Calendar view is rendered via UICollectionView.(Horizontal data flow and swipe)

* Compatible for iOS7

* It Only contains Monthly-View.

* You should specify total month range. Default : 25 Month (One Year before and after)

```
    let totalMonthCount : Int = 25
```

* Easy to get selected date model.
```
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let item = self.getCalendarItem(indexPath)
        print("Date : \(item.date)")
    }
```

