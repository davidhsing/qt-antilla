#ifndef ANTTHEME_P_H
#define ANTTHEME_P_H

#include <QtCore/QHash>
#include <QtCore/QJsonDocument>
#include <QtCore/QJsonObject>

#include "anttheme.h"
#include "antsystemthemehelper.h"

enum class Function : uint16_t
{
    GenColor,
    GenFontFamily,
    GenFontSize,
    GenFontLineHeight,
    GenRadius,

    Darker,
    Lighter,
    Alpha,
    OnBackground,

    Add,
    Subtract,
    Multiply,
    Divide
};

enum class Component : uint16_t
{
    AntButton,
    AntIconText,
    AntCopyableText,
    AntCaptionButton,
    AntTour,
    AntMenu,
    AntColorPicker,
    AntDivider,
    AntSwitch,
    AntScrollBar,
    AntSlider,
    AntTabs,
    AntToolTip,
    AntSelect,
    AntInput,
    AntInputInteger,
    AntInputNumber,
    AntRate,
    AntRadio,
    AntRadioBlock,
    AntCheckBox,
    AntDrawer,
    AntCollapse,
    AntCard,
    AntPagination,
    AntPopup,
    AntTimeline,
    AntTag,
    AntTable,
    AntMessage,
    AntAutoComplete,
    AntProgress,
    AntCarousel,
    AntBreadcrumb,
    AntImage,
    AntMultiSelect,
    AntDateTimePicker,
    AntNotification,
    AntPopconfirm,
    AntLabel,
    AntModal,
    AntText,
    AntTextArea,
    AntTransfer,
    AntTree,
    AntAudioDiagnosis,
    AntAlert,
    AntPopover,
    AntEmpty,
    AntSpin,
    AntStatusBar,
    AntFormItem,
    AntGroupBox,
    AntMaskOverlay,
    AntResult,
    AntShield,

    Size
};

static QHash<QString, Component> g_componentTable
{
    { "AntButton",          Component::AntButton           },
    { "AntIconText",        Component::AntIconText         },
    { "AntCopyableText",    Component::AntCopyableText     },
    { "AntCaptionButton",   Component::AntCaptionButton    },
    { "AntTour",            Component::AntTour             },
    { "AntMenu",            Component::AntMenu             },
    { "AntColorPicker",     Component::AntColorPicker      },
    { "AntDivider",         Component::AntDivider          },
    { "AntSwitch",          Component::AntSwitch           },
    { "AntScrollBar",       Component::AntScrollBar        },
    { "AntSlider",          Component::AntSlider           },
    { "AntTabs",            Component::AntTabs             },
    { "AntToolTip",         Component::AntToolTip          },
    { "AntSelect",          Component::AntSelect           },
    { "AntInput",           Component::AntInput            },
    { "AntInputInteger",    Component::AntInputInteger     },
    { "AntInputNumber",     Component::AntInputNumber      },
    { "AntRate",            Component::AntRate             },
    { "AntRadio",           Component::AntRadio            },
    { "AntRadioBlock",      Component::AntRadioBlock       },
    { "AntCheckBox",        Component::AntCheckBox         },
    { "AntDrawer",          Component::AntDrawer           },
    { "AntCollapse",        Component::AntCollapse         },
    { "AntCard",            Component::AntCard             },
    { "AntPagination",      Component::AntPagination       },
    { "AntPopup",           Component::AntPopup            },
    { "AntTimeline",        Component::AntTimeline         },
    { "AntTable",           Component::AntTable            },
    { "AntTag",             Component::AntTag              },
    { "AntMessage",         Component::AntMessage          },
    { "AntAutoComplete",    Component::AntAutoComplete     },
    { "AntProgress",        Component::AntProgress         },
    { "AntCarousel",        Component::AntCarousel         },
    { "AntBreadcrumb",      Component::AntBreadcrumb       },
    { "AntImage",           Component::AntImage            },
    { "AntMultiSelect",     Component::AntMultiSelect      },
    { "AntDateTimePicker",  Component::AntDateTimePicker   },
    { "AntNotification",    Component::AntNotification     },
    { "AntPopconfirm",      Component::AntPopconfirm       },
    { "AntLabel",           Component::AntLabel            },
    { "AntModal",           Component::AntModal            },
    { "AntText",            Component::AntText             },
    { "AntTextArea",        Component::AntTextArea         },
    { "AntTransfer",        Component::AntTransfer         },
    { "AntTree",            Component::AntTree             },
    { "AntAudioDiagnosis",  Component::AntAudioDiagnosis   },
    { "AntAlert",           Component::AntAlert            },
    { "AntPopover",         Component::AntPopover          },
    { "AntEmpty",           Component::AntEmpty            },
    { "AntSpin",            Component::AntSpin             },
    { "AntStatusBar",       Component::AntStatusBar        },
    { "AntFormItem",        Component::AntFormItem         },
    { "AntGroupBox",        Component::AntGroupBox         },
    { "AntMaskOverlay",     Component::AntMaskOverlay      },
    { "AntResult",          Component::AntResult           },
    { "AntShield",          Component::AntShield           },
};

struct ThemeData
{
    struct Component
    {
        QString path;
        QVariantMap *tokenMap;
        QMap<QString, QString> installTokenMap;
    };
    QObject *themeObject = nullptr;
    QMap<QString, Component> componentMap;
};

class AntThemePrivate
{
public:
    AntThemePrivate(AntTheme *q) : q_ptr(q) { }

    Q_DECLARE_PUBLIC(AntTheme);

    AntTheme *q_ptr = nullptr;
    AntTheme::DarkMode m_darkMode = AntTheme::DarkMode::Light;
    AntTheme::TextRenderType m_textRenderType = AntTheme::TextRenderType::QtRendering;
    AntSystemThemeHelper *m_helper { nullptr };
    QString m_themeIndexPath = ":/Antilla/theme/Index.json";
    QJsonObject m_indexObject;
    QMap<QString, QVariant> m_indexTokenTable;
    QMap<QString, QMap<QString, QVariant>> m_componentTokenTable;

    QMap<QObject *, ThemeData> m_defaultTheme;
    QMap<QObject *, ThemeData> m_customTheme;

    static AntThemePrivate *get(AntTheme *theme) { return theme->d_func(); }

    void parse$(QMap<QString, QVariant> &out, const QString &tokenName, const QString &expr);

    QColor colorFromIndexTable(const QString &tokenName);
    qreal numberFromIndexTable(const QString &tokenName);
    void parseIndexExpr(const QString &tokenName, const QString &expr);
    void parseComponentExpr(QVariantMap *tokenMapPtr, const QString &tokenName, const QString &expr);

    void reloadIndexTheme();
    void reloadComponentTheme(const QMap<QObject *, ThemeData> &dataMap);
    bool reloadComponentImport(QJsonObject &style, const QString &componentName);
    void reloadComponentThemeFile(QObject *themeObject, const QString &componentName, const ThemeData::Component &componentTheme);
    void reloadDefaultComponentTheme();
    void reloadCustomComponentTheme();

    void registerDefaultComponentTheme(const QString &component, const QString &themePath);
    void registerComponentTheme(QObject *theme,
                                const QString &component,
                                QVariantMap *themeMap,
                                const QString &themePath,
                                QMap<QObject *, ThemeData> &dataMap);
};

#endif // ANTTHEME_P_H
