/****************************************************************************
** Meta object code from reading C++ file 'ResetWindow.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.11.1)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../../../../../../s/client/onedrive/Product/QtViews/Support/ResetWindow.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'ResetWindow.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.11.1. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
struct qt_meta_stringdata_ResetWindow_t {
    QByteArrayData data[19];
    char stringdata0[259];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_ResetWindow_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_ResetWindow_t qt_meta_stringdata_ResetWindow = {
    {
QT_MOC_LITERAL(0, 0, 11), // "ResetWindow"
QT_MOC_LITERAL(1, 12, 12), // "StateChanged"
QT_MOC_LITERAL(2, 25, 0), // ""
QT_MOC_LITERAL(3, 26, 20), // "onResetButtonClicked"
QT_MOC_LITERAL(4, 47, 12), // "saveSettings"
QT_MOC_LITERAL(5, 60, 21), // "onCancelButtonClicked"
QT_MOC_LITERAL(6, 82, 22), // "onLearnMoreLinkClicked"
QT_MOC_LITERAL(7, 105, 9), // "onClosing"
QT_MOC_LITERAL(8, 115, 17), // "QQuickCloseEvent*"
QT_MOC_LITERAL(9, 133, 10), // "closeEvent"
QT_MOC_LITERAL(10, 144, 19), // "getLocalizedMessage"
QT_MOC_LITERAL(11, 164, 10), // "resourceId"
QT_MOC_LITERAL(12, 175, 5), // "isRTL"
QT_MOC_LITERAL(13, 181, 5), // "state"
QT_MOC_LITERAL(14, 187, 16), // "ResetWindowState"
QT_MOC_LITERAL(15, 204, 12), // "learnMoreUrl"
QT_MOC_LITERAL(16, 217, 20), // "descriptionLinkModel"
QT_MOC_LITERAL(17, 238, 9), // "UserInput"
QT_MOC_LITERAL(18, 248, 10) // "BeginReset"

    },
    "ResetWindow\0StateChanged\0\0"
    "onResetButtonClicked\0saveSettings\0"
    "onCancelButtonClicked\0onLearnMoreLinkClicked\0"
    "onClosing\0QQuickCloseEvent*\0closeEvent\0"
    "getLocalizedMessage\0resourceId\0isRTL\0"
    "state\0ResetWindowState\0learnMoreUrl\0"
    "descriptionLinkModel\0UserInput\0"
    "BeginReset"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_ResetWindow[] = {

 // content:
       7,       // revision
       0,       // classname
       0,    0, // classinfo
       6,   14, // methods
       4,   56, // properties
       1,   72, // enums/sets
       0,    0, // constructors
       0,       // flags
       1,       // signalCount

 // signals: name, argc, parameters, tag, flags
       1,    0,   44,    2, 0x06 /* Public */,

 // slots: name, argc, parameters, tag, flags
       3,    1,   45,    2, 0x0a /* Public */,
       5,    0,   48,    2, 0x0a /* Public */,
       6,    0,   49,    2, 0x0a /* Public */,
       7,    1,   50,    2, 0x0a /* Public */,

 // methods: name, argc, parameters, tag, flags
      10,    1,   53,    2, 0x02 /* Public */,

 // signals: parameters
    QMetaType::Void,

 // slots: parameters
    QMetaType::Void, QMetaType::Bool,    4,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void, 0x80000000 | 8,    9,

 // methods: parameters
    QMetaType::QString, QMetaType::QString,   11,

 // properties: name, type, flags
      12, QMetaType::Bool, 0x00095401,
      13, 0x80000000 | 14, 0x00495009,
      15, QMetaType::QString, 0x00095401,
      16, QMetaType::QObjectStar, 0x00095401,

 // properties: notify_signal_id
       0,
       0,
       0,
       0,

 // enums: name, flags, count, data
      14, 0x0,    2,   76,

 // enum data: key, value
      17, uint(ResetWindow::UserInput),
      18, uint(ResetWindow::BeginReset),

       0        // eod
};

void ResetWindow::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        ResetWindow *_t = static_cast<ResetWindow *>(_o);
        Q_UNUSED(_t)
        switch (_id) {
        case 0: _t->StateChanged(); break;
        case 1: _t->onResetButtonClicked((*reinterpret_cast< bool(*)>(_a[1]))); break;
        case 2: _t->onCancelButtonClicked(); break;
        case 3: _t->onLearnMoreLinkClicked(); break;
        case 4: _t->onClosing((*reinterpret_cast< QQuickCloseEvent*(*)>(_a[1]))); break;
        case 5: { QString _r = _t->getLocalizedMessage((*reinterpret_cast< QString(*)>(_a[1])));
            if (_a[0]) *reinterpret_cast< QString*>(_a[0]) = std::move(_r); }  break;
        default: ;
        }
    } else if (_c == QMetaObject::IndexOfMethod) {
        int *result = reinterpret_cast<int *>(_a[0]);
        {
            using _t = void (ResetWindow::*)();
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&ResetWindow::StateChanged)) {
                *result = 0;
                return;
            }
        }
    }
#ifndef QT_NO_PROPERTIES
    else if (_c == QMetaObject::ReadProperty) {
        ResetWindow *_t = static_cast<ResetWindow *>(_o);
        Q_UNUSED(_t)
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast< bool*>(_v) = _t->IsRTL(); break;
        case 1: *reinterpret_cast< ResetWindowState*>(_v) = _t->GetState(); break;
        case 2: *reinterpret_cast< QString*>(_v) = _t->GetLearnMoreUrl(); break;
        case 3: *reinterpret_cast< QObject**>(_v) = _t->GetDescriptionLinkModel(); break;
        default: break;
        }
    } else if (_c == QMetaObject::WriteProperty) {
    } else if (_c == QMetaObject::ResetProperty) {
    }
#endif // QT_NO_PROPERTIES
}

QT_INIT_METAOBJECT const QMetaObject ResetWindow::staticMetaObject = {
    { &QObject::staticMetaObject, qt_meta_stringdata_ResetWindow.data,
      qt_meta_data_ResetWindow,  qt_static_metacall, nullptr, nullptr}
};


const QMetaObject *ResetWindow::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *ResetWindow::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_ResetWindow.stringdata0))
        return static_cast<void*>(this);
    if (!strcmp(_clname, "IResetWindow"))
        return static_cast< IResetWindow*>(this);
    return QObject::qt_metacast(_clname);
}

int ResetWindow::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 6)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 6;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 6)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 6;
    }
#ifndef QT_NO_PROPERTIES
   else if (_c == QMetaObject::ReadProperty || _c == QMetaObject::WriteProperty
            || _c == QMetaObject::ResetProperty || _c == QMetaObject::RegisterPropertyMetaType) {
        qt_static_metacall(this, _c, _id, _a);
        _id -= 4;
    } else if (_c == QMetaObject::QueryPropertyDesignable) {
        _id -= 4;
    } else if (_c == QMetaObject::QueryPropertyScriptable) {
        _id -= 4;
    } else if (_c == QMetaObject::QueryPropertyStored) {
        _id -= 4;
    } else if (_c == QMetaObject::QueryPropertyEditable) {
        _id -= 4;
    } else if (_c == QMetaObject::QueryPropertyUser) {
        _id -= 4;
    }
#endif // QT_NO_PROPERTIES
    return _id;
}

// SIGNAL 0
void ResetWindow::StateChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 0, nullptr);
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE
