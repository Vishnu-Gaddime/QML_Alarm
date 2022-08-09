import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window

Dialog {
    id: alarmDialog
    title: "Add new alarm"
    modal: true
    standardButtons: DialogButtonBox.Ok | DialogButtonBox.Cancel

    property AlarmModel alarmModel

    function formatNumber(number) {
        return number < 10 && number >= 0 ? "0" + number : number.toString()
    }

    onAccepted: {
        alarmModel.append({
            "hour": hoursTumbler.currentIndex,
            "minute": minutesTumbler.currentIndex,
            "day": dayTumbler.currentIndex + 1,
            "month": monthTumbler.currentIndex + 1,
            "year": yearTumbler.years[yearTumbler.currentIndex],
            "activated": true,
            "label": "",
            "repeat": false,
            "daysToRepeat": [
                { "dayOfWeek": 0, "repeat": false },
                { "dayOfWeek": 1, "repeat": false },
                { "dayOfWeek": 2, "repeat": false },
                { "dayOfWeek": 3, "repeat": false },
                { "dayOfWeek": 4, "repeat": false },
                { "dayOfWeek": 5, "repeat": false },
                { "dayOfWeek": 6, "repeat": false }
            ],
        })
    }

    contentItem: RowLayout {
        RowLayout {
            id: rowTumbler

            Tumbler {
                id: hoursTumbler
                model: 24
                delegate: TumblerDelegate {
                    text: formatNumber(modelData)
                }
            }
            Tumbler {
                id: minutesTumbler
                model: 60
                delegate: TumblerDelegate {
                    text: formatNumber(modelData)
                }
            }
        }

        RowLayout {
            id: datePicker

            Layout.leftMargin: 20

            property alias dayTumbler: dayTumbler
             property alias monthTumbler: monthTumbler
             property alias yearTumbler: yearTumbler

            readonly property var days: [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

            Tumbler {
                id: dayTumbler

                function updateModel() {

                    var previousIndex = dayTumbler.currentIndex
                    var array = []
                    var newDays = datePicker.days[monthTumbler.currentIndex]
                    for (var i = 1; i <= newDays; ++i)
                        array.push(i)
                    dayTumbler.model = array
                    dayTumbler.currentIndex = Math.min(newDays - 1, previousIndex)
                }

                Component.onCompleted: updateModel()

                delegate: TumblerDelegate {
                    text: formatNumber(modelData)
                }
            }
            Tumbler {
                id: monthTumbler

                onCurrentIndexChanged: dayTumbler.updateModel()

                model: 12
                delegate: TumblerDelegate {
                    text: window.locale.standaloneMonthName(modelData, Locale.ShortFormat)
                }
            }
            Tumbler {
                id: yearTumbler

                readonly property var years: (function() {
                    var currentYear = new Date().getFullYear()
                    return [0, 1, 2, 3, 4, 5, 6, 7, 8, 9].map(function(value) { return value + currentYear; })
                })()

                model: years
                delegate: TumblerDelegate {
                    text: formatNumber(modelData)
                }
            }

        }
    }
}
