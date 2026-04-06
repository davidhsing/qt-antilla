import QtQuick
import Antilla.Basic

Item {
    id: control

    enum ProgressType {
        TypeLine = 0,
        TypeCircle = 1,
        TypeDashboard = 2
    }

    enum ProgressStatus {
        StatusNormal = 0,
        StatusSuccess = 1,
        StatusException = 2,
        StatusActive = 3
    }

    property bool animationEnabled: AntTheme.animationEnabled
    property int type: AntProgress.TypeLine
    property int status: AntProgress.StatusNormal
    property real percent: 0
    property real barThickness: 8
    property string strokeLineCap: 'round'
    property int steps: 0
    property int currentStep: 0
    property real gap: 4
    property real gapDegree: 60
    property bool useGradient: false
    property var gradientStops: ({
        '0%': control.colorBar,
        '100%': control.colorBar
    })
    property bool infoVisible: true
    property int precision: 0
    property var formatter: () => {
        switch (control.status) {
            case AntProgress.StatusSuccess:
                return control.type === AntProgress.TypeLine ? AntIcon.CheckCircleFilled : AntIcon.CheckOutlined;
            case AntProgress.StatusException:
                return control.type === AntProgress.TypeLine ? AntIcon.CloseCircleFilled : AntIcon.CloseOutlined;
            default:
                return `${control.percent.toFixed(control.precision)}%`;
        }
    }
    property color colorBar: {
        switch (control.status) {
            case AntProgress.StatusSuccess: return AntTheme.AntProgress.colorBarSuccess;
            case AntProgress.StatusException: return AntTheme.AntProgress.colorBarException;
            case AntProgress.StatusNormal: return AntTheme.AntProgress.colorBarNormal;
            case AntProgress.StatusActive : return AntTheme.AntProgress.colorBarNormal;
            default: return AntTheme.AntProgress.colorBarNormal;
        }
    }
    property color colorTrack: AntTheme.AntProgress.colorTrack
    property color colorInfo: {
        switch (control.status) {
            case AntProgress.StatusSuccess: return AntTheme.AntProgress.colorInfoSuccess;
            case AntProgress.StatusException: return AntTheme.AntProgress.colorInfoException;
            default: return AntTheme.AntProgress.colorInfoNormal;
        }
    }
    property Component infoDelegate: AntIconText {
        color: control.colorInfo
        font.family: isIcon ? 'Antilla-Icons' : AntTheme.AntProgress.fontFamily
        font.pixelSize: type === AntProgress.TypeLine ? AntTheme.AntProgress.fontSize + (!isIcon ? 0 : 2) : AntTheme.AntProgress.fontSize + (!isIcon ? 8 : 16)
        text: isIcon ? String.fromCharCode(formatText) : formatText
        property var formatText: control.formatter()
        property bool isIcon: typeof formatText == 'number'
    }

    objectName: '__AntProgress__'
    height: 16
    onPercentChanged: __canvas.requestPaint();
    onStepsChanged: __canvas.requestPaint();
    onCurrentStepChanged: __canvas.requestPaint();
    onBarThicknessChanged: __canvas.requestPaint();
    onStrokeLineCapChanged: __canvas.requestPaint();
    onGapChanged: __canvas.requestPaint();
    onGapDegreeChanged: __canvas.requestPaint();
    onUseGradientChanged: __canvas.requestPaint();
    onGradientStopsChanged: __canvas.requestPaint();
    onColorBarChanged: __canvas.requestPaint();
    onColorTrackChanged: __canvas.requestPaint();
    onColorInfoChanged: __canvas.requestPaint();

    Behavior on percent { enabled: control.animationEnabled; NumberAnimation { duration: AntTheme.Primary.durationMid } }
    Behavior on colorBar { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationMid } }
    Behavior on colorTrack { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationMid } }
    Behavior on colorInfo { enabled: control.animationEnabled; ColorAnimation { duration: AntTheme.Primary.durationMid } }

    Canvas {
        id: __canvas
        height: parent.height
        anchors.left: parent.left
        anchors.right: control.type === AntProgress.TypeLine ? __infoLoader.left : parent.right
        anchors.rightMargin: control.type === AntProgress.TypeLine ? 5 : 0
        antialiasing: true
        onWidthChanged: requestPaint();
        onHeightChanged: requestPaint();
        onActiveWidthChanged:  requestPaint();

        property color activeColor: AntThemeFunctions.alpha(AntTheme.Primary.colorBgBase, 0.15)
        property real activeWidth: 0
        property real progressWidth: control.percent * 0.01 * width

        NumberAnimation on activeWidth {
            running: control.type === AntProgress.TypeLine && control.status === AntProgress.StatusActive
            from: 0
            to: __canvas.progressWidth
            loops: Animation.Infinite
            duration: 2000
            easing.type: Easing.OutQuint
        }

        function createGradient(ctx) {
            let gradient = ctx.createLinearGradient(0, 0, width, height);
            Object.keys(control.gradientStops).forEach(stop => {
                const percentage = parseFloat(stop) / 100;
                gradient.addColorStop(percentage, control.gradientStops[stop]);
            });
            return gradient;
        }

        function getCurrentColor(ctx) {
            return control.useGradient ? createGradient(ctx) : control.colorBar;
        }

        function drawStrokeWithRadius(ctx, x, y, radius, startAngle, endAngle, color) {
            ctx.beginPath();
            ctx.arc(x, y, radius, startAngle, endAngle);
            ctx.lineWidth = control.barThickness;
            ctx.strokeStyle = color;
            ctx.stroke();
        }

        function drawRoundLine(ctx, x, y, width, height, radius, color) {
            ctx.beginPath();
            if (control.strokeLineCap === 'butt') {
                ctx.moveTo(x, y + height / 2);
                ctx.lineTo(x + width, y + height / 2);
            } else {
                ctx.moveTo(x + radius, y + height / 2);
                ctx.lineTo(x + width - radius * 2, y + radius);
            }
            ctx.lineWidth = control.barThickness;
            ctx.lineCap = control.strokeLineCap;
            ctx.strokeStyle = color;
            ctx.stroke();
        }

        function drawLine(ctx) {
            const color = getCurrentColor(ctx);
            if (control.steps > 0) {
                const stepWidth = (width - ((control.steps - 1) * control.gap)) / control.steps;
                const stepHeight = control.barThickness;
                const stepY = (__canvas.height - stepHeight) / 2;

                for (let i = 0; i < control.steps; i++) {
                    const stepX = i * control.gap + i * stepWidth;
                    ctx.fillStyle = control.colorTrack;
                    ctx.fillRect(stepX, stepY, stepWidth, stepHeight);
                }

                for (let ii = 0; ii < control.currentStep; ii++) {
                    const stepX = ii * control.gap + ii * stepWidth;
                    ctx.fillStyle = color;
                    ctx.fillRect(stepX, stepY, stepWidth, stepHeight);
                }
            } else {
                const x = 0;
                const y = (height - control.barThickness) / 2;
                const progressWidth = control.percent * 0.01 * width;
                const radius = control.strokeLineCap === 'round' ? control.barThickness / 2 : 0;

                drawRoundLine(ctx, x, y, width, control.barThickness, radius, control.colorTrack);

                if (progressWidth > 0) {
                    drawRoundLine(ctx, x, y, progressWidth, control.barThickness, radius, color);
                    /*! 绘制激活状态动画 */
                    if (control.status === AntProgress.StatusActive) {
                        drawRoundLine(ctx, x, y, __canvas.activeWidth, control.barThickness, radius, __canvas.activeColor);
                    }
                }
            }
        }

        function drawCircle(ctx, centerX, centerY, radius) {
            /*! 确保绘制不会超出边界 */
            radius = Math.max(0, Math.min(radius, Math.min(width, height) / 2 - control.barThickness));
            const color = getCurrentColor(ctx);
            if (control.steps > 0) {
                /*! 计算每个步骤的弧长，考虑圆角影响 */
                const gap = control.gap;
                const circumference = Math.PI * 2 * radius;
                const totalGapLength = gap * control.steps;
                const availableLength = circumference - totalGapLength;
                const stepLength = availableLength / control.steps;

                /*! 绘制背景圆环段 */
                for (let i = 0; i < control.steps; i++) {
                    const gapDistance = (gap * i) / radius;
                    const stepAngle = stepLength / radius;
                    const startAngle = (i * stepAngle) + gapDistance - Math.PI / 2;
                    const endAngle = startAngle + stepLength / radius;

                    drawStrokeWithRadius(ctx, centerX, centerY, radius, startAngle, endAngle, control.colorTrack);
                }

                /*! 绘制已完成的步骤 */
                for (let ii = 0; ii < control.currentStep; ii++) {
                    const gapDistance = (gap * ii) / radius;
                    const stepAngle = stepLength / radius;
                    const startAngle = (ii * stepAngle) + gapDistance - Math.PI / 2;
                    const endAngle = startAngle + stepLength / radius;

                    drawStrokeWithRadius(ctx, centerX, centerY, radius, startAngle, endAngle, color);
                }
            } else {
                /*! 非步骤条需要使用线帽 */
                ctx.lineCap = control.strokeLineCap;

                /*! 绘制轨道 */
                drawStrokeWithRadius(ctx, centerX, centerY, radius, 0, Math.PI * 2, control.colorTrack);

                /*! 绘制进度 */
                const progress = control.percent * 0.01 * Math.PI * 2;
                drawStrokeWithRadius(ctx, centerX, centerY, radius, -Math.PI / 2, progress - Math.PI / 2, color);
            }
        }

        function drawDashboard(ctx, centerX, centerY, radius) {
            radius = Math.max(0,Math.min(radius, Math.min(width, height) / 2 - control.barThickness));
            /* ! 计算开始和结束角度 */
            const gapRad = Math.min(Math.max(control.gapDegree, 0), 295) * Math.PI / 180;
            const startAngle = Math.PI / 2 + gapRad / 2;
            const endAngle = Math.PI * 2.5 - gapRad / 2;
            const color = getCurrentColor(ctx);
            
            if (control.steps > 0) {
               /*! 计算每个步骤的弧长，考虑仪表盘缺口和步进间隔 */
                const gap = control.gap;
                const availableAngle = endAngle - startAngle;
                const totalGapAngle = (gap / radius) * (control.steps - 1);
                const stepAngle = (availableAngle - totalGapAngle) / control.steps;

                /*! 绘制背景圆环段 */
                for (let i = 0; i < control.steps; i++) {
                    const stepStartAngle = startAngle + i * (stepAngle + gap / radius);
                    const stepEndAngle = stepStartAngle + stepAngle;
                    drawStrokeWithRadius(ctx, centerX, centerY, radius, stepStartAngle, stepEndAngle, control.colorTrack);
                }

                /*! 绘制已完成的步骤 */
                for (let ii = 0; ii < control.currentStep; ii++) {
                    const stepStartAngle = startAngle + ii * (stepAngle + gap / radius);
                    const stepEndAngle = stepStartAngle + stepAngle;
                    drawStrokeWithRadius(ctx, centerX, centerY, radius, stepStartAngle, stepEndAngle, color);
                }
            } else {
                /*! 非步骤条需要使用线帽 */
                ctx.lineCap = control.strokeLineCap;

                /*！绘制背景轨道 */
                drawStrokeWithRadius(ctx, centerX, centerY, radius, startAngle, endAngle, control.colorTrack);

                /*计算进度条角度 */
                const progressRange = endAngle - startAngle;
                const progress = control.percent * 0.01 * progressRange;

                /*绘制进度 */
                drawStrokeWithRadius(ctx, centerX, centerY, radius, startAngle, startAngle + progress, color);
            }
        }

        onPaint: {
            let ctx = getContext('2d');

            let centerX = width / 2;
            let centerY = height / 2;
            let radius = Math.min(width, height) / 2 - control.barThickness;

            /*! 清除画布 */
            ctx.clearRect(0, 0, width, height);

            switch (control.type) {
            case AntProgress.TypeLine:
                drawLine(ctx); break;
            case AntProgress.TypeCircle:
                drawCircle(ctx, centerX, centerY, radius); break;
            case AntProgress.TypeDashboard:
                drawDashboard(ctx, centerX, centerY, radius); break;
            default: break;
            }
        }
    }

    Loader {
        id: __infoLoader
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: control.type === AntProgress.TypeLine ? undefined : parent.horizontalCenter
        anchors.right: control.type === AntProgress.TypeLine ? parent.right : undefined
        sourceComponent: control.infoDelegate
        active: control.infoVisible
        visible: active
    }
}
