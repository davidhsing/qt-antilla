#ifndef ANTTHEME_H
#define ANTTHEME_H

#include <QtQml/qqml.h>

#include "../antglobal.h"
#include "../antdefinitions.h"

QT_FORWARD_DECLARE_CLASS(AntThemePrivate)

class ANTILLA_EXPORT AntTheme : public QObject
{
    Q_OBJECT
    QML_SINGLETON
    QML_NAMED_ELEMENT(AntTheme)

    Q_PROPERTY(bool isDark READ isDark NOTIFY isDarkChanged)
    Q_PROPERTY(DarkMode darkMode READ darkMode WRITE setDarkMode NOTIFY darkModeChanged FINAL)
    Q_PROPERTY(TextRenderType textRenderType READ textRenderType WRITE setTextRenderType NOTIFY textRenderTypeChanged FINAL)

    ANT_PROPERTY_INIT(bool, animationEnabled, setAnimationEnabled, true);

    ANT_PROPERTY_READONLY(QVariantMap, Primary); /*! 所有 {Index.json} 中的变量 */

    ANT_PROPERTY_READONLY(QVariantMap, AntButton);
    ANT_PROPERTY_READONLY(QVariantMap, AntIconText);
    ANT_PROPERTY_READONLY(QVariantMap, AntCopyableText);
    ANT_PROPERTY_READONLY(QVariantMap, AntCaptionButton);
    ANT_PROPERTY_READONLY(QVariantMap, AntTour);
    ANT_PROPERTY_READONLY(QVariantMap, AntMenu);
    ANT_PROPERTY_READONLY(QVariantMap, AntColorPicker);
    ANT_PROPERTY_READONLY(QVariantMap, AntDivider);
    ANT_PROPERTY_READONLY(QVariantMap, AntSwitch);
    ANT_PROPERTY_READONLY(QVariantMap, AntScrollBar);
    ANT_PROPERTY_READONLY(QVariantMap, AntSlider);
    ANT_PROPERTY_READONLY(QVariantMap, AntTabs);
    ANT_PROPERTY_READONLY(QVariantMap, AntToolTip);
    ANT_PROPERTY_READONLY(QVariantMap, AntSelect);
    ANT_PROPERTY_READONLY(QVariantMap, AntInput);
    ANT_PROPERTY_READONLY(QVariantMap, AntInputInteger);
    ANT_PROPERTY_READONLY(QVariantMap, AntInputNumber);
    ANT_PROPERTY_READONLY(QVariantMap, AntRate);
    ANT_PROPERTY_READONLY(QVariantMap, AntRadio);
    ANT_PROPERTY_READONLY(QVariantMap, AntRadioBlock);
    ANT_PROPERTY_READONLY(QVariantMap, AntCheckBox);
    ANT_PROPERTY_READONLY(QVariantMap, AntDrawer);
    ANT_PROPERTY_READONLY(QVariantMap, AntCollapse);
    ANT_PROPERTY_READONLY(QVariantMap, AntCard);
    ANT_PROPERTY_READONLY(QVariantMap, AntPagination);
    ANT_PROPERTY_READONLY(QVariantMap, AntPopup);
    ANT_PROPERTY_READONLY(QVariantMap, AntTimeline);
    ANT_PROPERTY_READONLY(QVariantMap, AntTag);
    ANT_PROPERTY_READONLY(QVariantMap, AntTable);
    ANT_PROPERTY_READONLY(QVariantMap, AntMessage);
    ANT_PROPERTY_READONLY(QVariantMap, AntAutoComplete);
    ANT_PROPERTY_READONLY(QVariantMap, AntProgress);
    ANT_PROPERTY_READONLY(QVariantMap, AntCarousel);
    ANT_PROPERTY_READONLY(QVariantMap, AntBreadcrumb);
    ANT_PROPERTY_READONLY(QVariantMap, AntImage);
    ANT_PROPERTY_READONLY(QVariantMap, AntMultiSelect);
    ANT_PROPERTY_READONLY(QVariantMap, AntDateTimePicker);
    ANT_PROPERTY_READONLY(QVariantMap, AntNotification);
    ANT_PROPERTY_READONLY(QVariantMap, AntPopconfirm);
    ANT_PROPERTY_READONLY(QVariantMap, AntLabel);
    ANT_PROPERTY_READONLY(QVariantMap, AntModal);
    ANT_PROPERTY_READONLY(QVariantMap, AntText);
    ANT_PROPERTY_READONLY(QVariantMap, AntTextArea);
    ANT_PROPERTY_READONLY(QVariantMap, AntTransfer);
    ANT_PROPERTY_READONLY(QVariantMap, AntTree);
    ANT_PROPERTY_READONLY(QVariantMap, AntAudioDiagnosis);
    ANT_PROPERTY_READONLY(QVariantMap, AntAlert);
    ANT_PROPERTY_READONLY(QVariantMap, AntPopover);
    ANT_PROPERTY_READONLY(QVariantMap, AntEmpty);
    ANT_PROPERTY_READONLY(QVariantMap, AntSpin);
    ANT_PROPERTY_READONLY(QVariantMap, AntStatusBar);
    ANT_PROPERTY_READONLY(QVariantMap, AntFormItem);
    ANT_PROPERTY_READONLY(QVariantMap, AntGroupBox);
    ANT_PROPERTY_READONLY(QVariantMap, AntMaskOverlay);
    ANT_PROPERTY_READONLY(QVariantMap, AntResult);
    ANT_PROPERTY_READONLY(QVariantMap, AntShield);

public:
    enum class DarkMode {
        Light = 0,
        Dark,
        System
    };
    Q_ENUM(DarkMode);

    enum class TextRenderType {
        QtRendering = 0,
        NativeRendering = 1,
        CurveRendering = 2
    };
    Q_ENUM(TextRenderType);

    ~AntTheme();

    static AntTheme *instance();
    static AntTheme *create(QQmlEngine *, QJSEngine *);

    bool isDark() const;

    DarkMode darkMode() const;
    void setDarkMode(DarkMode mode);

    TextRenderType textRenderType() const;
    void setTextRenderType(TextRenderType renderType);

    /**
     * @brief 注册自定义组件主题
     * @param themeObject 主题对象指针
     * @param component 组件名
     * @param themeMap 主题属性映射
     * @param themePath 主题路径
     */
    void registerCustomComponentTheme(QObject *themeObject, const QString &component, QVariantMap *themeMap, const QString &themePath);

    /**
     * @brief 重新载入(重新计算)主题
     */
    Q_INVOKABLE void reloadTheme();

    /**
     * @brief 设置文本基础色{AntTheme.Primary.colorTextBase}
     * @param lightAndDark 明亮和暗黑模式颜色字符串,类似于{#000|#fff}
     */
    Q_INVOKABLE void installThemeColorTextBase(const QString &lightAndDark);
    /**
     * @brief 设置背景基础色{AntTheme.Primary.colorBgBase}
     * @param lightAndDark 明亮和暗黑模式颜色字符串,类似于{#fff|#000}
     */
    Q_INVOKABLE void installThemeColorBgBase(const QString &lightAndDark);
    /**
     * @brief 设置背景禁用色{AntTheme.Primary.colorBgDisabled}
     * @param colorDisabled 禁用颜色
     */
    Q_INVOKABLE void installThemeColorBgDisabled(const QString &colorDisabled);
    /**
     * @brief 设置主基础色{AntTheme.Primary.colorPrimaryBase}
     * @param colorBase 主基础颜色
     */
    Q_INVOKABLE void installThemePrimaryColorBase(const QColor &colorBase);
    /**
     * @brief 设置字体基础大小{AntTheme.Primary.fontSizeBase}
     * @param fontSizeBase 基础字体像素大小
     */
    Q_INVOKABLE void installThemePrimaryFontSizeBase(int fontSizeBase);
    /**
     * @brief 设置基础字体族{AntTheme.Primary.fontFamilyBase}
     * @param familiesBase 基础字体族
     */
    Q_INVOKABLE void installThemePrimaryFontFamiliesBase(const QString &familiesBase);
    /**
     * @brief 设置圆角半径基础大小{AntTheme.Primary.radiusBase}
     * @param radiusBase 基础圆角半径大小
     */
    Q_INVOKABLE void installThemePrimaryRadiusBase(int radiusBase);
    /**
     * @brief 设置动画基础速度
     * @param durationFast [Fast 动画持续时间(ms)]
     * @param durationMid  [Mid  动画持续时间(ms)]
     * @param durationSlow [Slow 动画持续时间(ms)]
     */
    Q_INVOKABLE void installThemePrimaryAnimationBase(int durationFast, int durationMid, int durationSlow);


    /**
     * @brief 设置Index主题
     * @param themePath 主题路径(为空时重置为默认)
     */
    Q_INVOKABLE void installIndexTheme(const QString &themePath);
    /**
     * @brief 设置Index主题令牌
     * @param token 令牌名
     * @param value 令牌值
     * @warning 支持Token生成函数(genColor/genFont/genFontSize/genRadius)
     */
    Q_INVOKABLE void installIndexToken(const QString &token, const QString &value);

    /**
     * @brief 设置组件主题
     * @param component 组件名称
     * @param themePath 主题路径
     */
    Q_INVOKABLE void installComponentTheme(const QString &component, const QString &themePath);
    /**
     * @brief 设置组件主题令牌
     * @param component 组件名称
     * @param token 令牌名
     * @param value 令牌值
     */
    Q_INVOKABLE void installComponentToken(const QString &component, const QString &token, const QString &value);

signals:
    void isDarkChanged();
    void darkModeChanged();
    void textRenderTypeChanged();

private:
    explicit AntTheme(QObject *parent = nullptr);

    Q_DECLARE_PRIVATE(AntTheme);
    QScopedPointer<AntThemePrivate> d_ptr;
};

#endif // ANTTHEME_H
