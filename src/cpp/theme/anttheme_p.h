#ifndef HUSTHEME_P_H
#define HUSTHEME_P_H

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
    HusButton,
    HusIconText,
    HusCopyableText,
    HusCaptionButton,
    HusTour,
    HusMenu,
    HusColorPicker,
    HusDivider,
    HusSwitch,
    HusScrollBar,
    HusSlider,
    HusTabs,
    HusToolTip,
    HusSelect,
    HusInput,
    HusInputInteger,
    HusInputNumber,
    HusRate,
    HusRadio,
    HusRadioBlock,
    HusCheckBox,
    HusDrawer,
    HusCollapse,
    HusCard,
    HusPagination,
    HusPopup,
    HusTimeline,
    HusTag,
    HusTable,
    HusMessage,
    HusAutoComplete,
    HusProgress,
    HusCarousel,
    HusBreadcrumb,
    HusImage,
    HusMultiSelect,
    HusDateTimePicker,
    HusNotification,
    HusPopconfirm,
    HusLabel,
    HusModal,
    HusText,
    HusTextArea,
    HusTransfer,
    HusTree,
    HusAudioDiagnosis,
    HusAlert,
    HusPopover,
    HusEmpty,
    HusSpin,
    HusStatusBar,
    HusFormItem,
    HusGroupBox,
    HusMaskOverlay,
    HusResult,
    HusShield,

    Size
};

static QHash<QString, Component> g_componentTable
{
    { "HusButton",          Component::HusButton           },
    { "HusIconText",        Component::HusIconText         },
    { "HusCopyableText",    Component::HusCopyableText     },
    { "HusCaptionButton",   Component::HusCaptionButton    },
    { "HusTour",            Component::HusTour             },
    { "HusMenu",            Component::HusMenu             },
    { "HusColorPicker",     Component::HusColorPicker      },
    { "HusDivider",         Component::HusDivider          },
    { "HusSwitch",          Component::HusSwitch           },
    { "HusScrollBar",       Component::HusScrollBar        },
    { "HusSlider",          Component::HusSlider           },
    { "HusTabs",            Component::HusTabs             },
    { "HusToolTip",         Component::HusToolTip          },
    { "HusSelect",          Component::HusSelect           },
    { "HusInput",           Component::HusInput            },
    { "HusInputInteger",    Component::HusInputInteger     },
    { "HusInputNumber",     Component::HusInputNumber      },
    { "HusRate",            Component::HusRate             },
    { "HusRadio",           Component::HusRadio            },
    { "HusRadioBlock",      Component::HusRadioBlock       },
    { "HusCheckBox",        Component::HusCheckBox         },
    { "HusDrawer",          Component::HusDrawer           },
    { "HusCollapse",        Component::HusCollapse         },
    { "HusCard",            Component::HusCard             },
    { "HusPagination",      Component::HusPagination       },
    { "HusPopup",           Component::HusPopup            },
    { "HusTimeline",        Component::HusTimeline         },
    { "HusTable",           Component::HusTable            },
    { "HusTag",             Component::HusTag              },
    { "HusMessage",         Component::HusMessage          },
    { "HusAutoComplete",    Component::HusAutoComplete     },
    { "HusProgress",        Component::HusProgress         },
    { "HusCarousel",        Component::HusCarousel         },
    { "HusBreadcrumb",      Component::HusBreadcrumb       },
    { "HusImage",           Component::HusImage            },
    { "HusMultiSelect",     Component::HusMultiSelect      },
    { "HusDateTimePicker",  Component::HusDateTimePicker   },
    { "HusNotification",    Component::HusNotification     },
    { "HusPopconfirm",      Component::HusPopconfirm       },
    { "HusLabel",           Component::HusLabel            },
    { "HusModal",           Component::HusModal            },
    { "HusText",            Component::HusText             },
    { "HusTextArea",        Component::HusTextArea         },
    { "HusTransfer",        Component::HusTransfer         },
    { "HusTree",            Component::HusTree             },
    { "HusAudioDiagnosis",  Component::HusAudioDiagnosis   },
    { "HusAlert",           Component::HusAlert            },
    { "HusPopover",         Component::HusPopover          },
    { "HusEmpty",           Component::HusEmpty            },
    { "HusSpin",            Component::HusSpin             },
    { "HusStatusBar",       Component::HusStatusBar        },
    { "HusFormItem",        Component::HusFormItem         },
    { "HusGroupBox",        Component::HusGroupBox         },
    { "HusMaskOverlay",     Component::HusMaskOverlay      },
    { "HusResult",          Component::HusResult           },
    { "HusShield",          Component::HusShield           },
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

class HusThemePrivate
{
public:
    HusThemePrivate(HusTheme *q) : q_ptr(q) { }

    Q_DECLARE_PUBLIC(HusTheme);

    HusTheme *q_ptr = nullptr;
    HusTheme::DarkMode m_darkMode = HusTheme::DarkMode::Light;
    HusTheme::TextRenderType m_textRenderType = HusTheme::TextRenderType::QtRendering;
    HusSystemThemeHelper *m_helper { nullptr };
    QString m_themeIndexPath = ":/Antilla/theme/Index.json";
    QJsonObject m_indexObject;
    QMap<QString, QVariant> m_indexTokenTable;
    QMap<QString, QMap<QString, QVariant>> m_componentTokenTable;

    QMap<QObject *, ThemeData> m_defaultTheme;
    QMap<QObject *, ThemeData> m_customTheme;

    static HusThemePrivate *get(HusTheme *theme) { return theme->d_func(); }

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

#endif // HUSTHEME_P_H
