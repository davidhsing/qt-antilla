import QtQuick
import QtQuick.Controls.Basic
import Antilla.Basic
import '../../Controls'

Flickable {
    contentHeight: column.height
    ScrollBar.vertical: AntScrollBar { }

    Column {
        id: column
        width: parent.width - 15
        spacing: 30

        Description {
            desc: qsTr(`
# AntMultiSelect 选择器\n
下拉多选器。\n
* **继承自 { [AntSelect](internal://AntSelect) }**\n
\n<br/>
\n### 支持的代理：\n
- **prefixDelegate: Component** 前缀代理\n
- **suffixDelegate: Component** 后缀代理\n
- **tagDelegate: Component** 标签代理，代理可访问属性：\n
  - \`index: var\` 标签索引\n
  - \`tagData: var\` 标签数据\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
options | list | [] | 选项模型列表
filterOption | function | - | 输入项将使用该函数进行筛选
initValue | var | [] | 初始值
activeValue | var | [] | 绑定值
text | string | '' | 当前输入文本
prefix | string | '' | 前缀文本
suffix | string | '' | 后缀文本
genDefaultKey | bool | true | 是否生成默认键(如果没有给定key则为label)
selectedKeys | list | [] | 选中项的键
searchEnabled | bool | true | 是否启用搜索
placeholderText | string | '' | 占位符文本
tagCount | int(readonly) | 0 | 当前(选择)标签数量
maxTagCount | int | -1 | 最多显示多少个标签(-1无限制)
tagSpacing | int | 5 | 标签间隔
colorTagText | color | - | 标签文本颜色
colorTagBg | color | - | 标签背景颜色
radiusTagBg | [AntRadius](internal://AntRadius) | - | 标签圆角半径
radiusPopupBg | [AntRadius](internal://AntRadius) | - | 弹窗圆角半径
\n<br/>
\n### 支持的函数：\n
- \`findKey(key: string)\` 查找 \`key\` 处的选项数据\n
- \`filter()\` 过滤选项列表\n
- \`removeTagAtKey(key: string)\` 删除 \`key\` 处的标签\n
- \`removeTagAtIndex(index: int)\` 删除 \`index\` 处的标签\n
- \`clearTag()\` 清空标签\n
- \`clearInput()\` 清空输入\n
- \`openPopup()\` 打开弹出框\n
- \`closePopup()\` 关闭弹出框\n
\n<br/>
\n### 支持的信号：\n
- \`searched(input: string)\` 搜索补全项的时发出\n
  - \`input\` 输入文本\n
- \`selected(option: var)\` 选择补全项时发出\n
  - \`option\` 选择的选项\n
- \`tagRemoved(option: var)\` 删除标签项时发出\n
  - \`option\` 删除的选项\n
\n<br/>
\n### 注意事项：\n
\`options\` 列表通常需要 \`key\` 属性，如果未给出将使用 \`label\` 作为 \`key\`
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
- 弹出一个多选下拉菜单给用户多选操作，用于扩展单项选择器([AntSelect](internal://AntSelect))，或者需要一个更优雅的多选器时。\n
                       `)
        }

        ThemeToken {
            source: 'AntMultiSelect'
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr(`基本使用`)
            desc: qsTr(`
通过 \`options\` 设置数据源。\n
通过 \`filterOption\` 设置过滤选项，它是形如：\`function(input: string, option: var): bool { }\` 的函数。\n
                       `)
            code: `
import QtQuick
import Antilla.Basic

Row {
    width: parent.width
    spacing: 10

    AntMultiSelect {
        width: 200
        filterOption: (input, option) => option.label.toUpperCase().indexOf(input.toUpperCase()) !== -1
        Component.onCompleted: {
            const list = [];
            for (let i = 10; i < 36; i++) {
                list.push({
                    label: i.toString(36) + i,
                    value: i.toString(36) + i,
                });
            }
            options = list;
        }
    }
}
            `
            exampleDelegate: Row {
                spacing: 10

                AntMultiSelect {
                    width: 200
                    filterOption: (input, option) => option.label.toUpperCase().indexOf(input.toUpperCase()) !== -1
                    Component.onCompleted: {
                        const list = [];
                        for (let i = 10; i < 36; i++) {
                            list.push({
                                label: i.toString(36) + i,
                                value: i.toString(36) + i,
                            });
                        }
                        options = list;
                    }
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr(`自定义下拉文本`)
            desc: qsTr(`
通过 \`initValue\` 属性设置初始值。\n
通过 \`textRole\` 设置弹窗显示的文本角色。\n
通过 \`searchEnabled\` 设置是否启用搜索。\n
通过 \`placeholderText\` 设置占位符文本。\n
                       `)
            code: `
import QtQuick
import Antilla.Basic

Row {
    width: parent.width
    spacing: 10

    AntMultiSelect {
        width: 200
        textRole: 'desc'
        searchEnabled: false
        placeholderText: 'selected one country'
        options: [
            {
                label: 'China',
                value: 'china',
                desc: '🇨🇳 China (中国)',
            },
            {
                label: 'USA',
                value: 'usa',
                desc: '🇺🇸 USA (美国)',
            },
            {
                label: 'Japan',
                value: 'japan',
                desc: '🇯🇵 Japan (日本)',
            },
            {
                label: 'Korea',
                value: 'korea',
                desc: '🇰🇷 Korea (韩国)',
            },
        ]
        initValue: ['china', 'usa']
    }
}
            `
            exampleDelegate: Row {
                spacing: 10

                AntMultiSelect {
                    width: 200
                    textRole: 'desc'
                    searchEnabled: false
                    placeholderText: 'selected one country'
                    options: [
                        {
                            label: 'China',
                            value: 'china',
                            desc: '🇨🇳 China (中国)',
                        },
                        {
                            label: 'USA',
                            value: 'usa',
                            desc: '🇺🇸 USA (美国)',
                        },
                        {
                            label: 'Japan',
                            value: 'japan',
                            desc: '🇯🇵 Japan (日本)',
                        },
                        {
                            label: 'Korea',
                            value: 'korea',
                            desc: '🇰🇷 Korea (韩国)',
                        },
                    ]
                    initValue: ['china', 'usa']
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr(`前缀和后缀`)
            desc: qsTr(`
通过 \`prefix\` 设置前缀文本。\n
通过 \`suffix\` 设置后缀文本。\n
通过 \`prefixDelegate\` 设置前缀代理。\n
通过 \`suffixDelegate\` 设置后缀代理。\n
                       `)
            code: `
import QtQuick
import Antilla.Basic

Row {
    width: parent.width
    spacing: 10

    AntMultiSelect {
        width: 200
        prefix: 'User'
        options: [
            { value: 'jack', label: 'Jack' },
            { value: 'lucy', label: 'Lucy' },
            { value: 'David', label: 'david' },
            { value: 'disabled', label: 'Disabled', disabled: true },
        ]
    }

    AntMultiSelect {
        width: 200
        prefixDelegate: AntIconText { iconSource: AntIcon.SmileOutlined }
        options: [
            { value: 'jack', label: 'Jack' },
            { value: 'lucy', label: 'Lucy' },
            { value: 'David', label: 'david' },
            { value: 'disabled', label: 'Disabled', disabled: true },
        ]
    }

    AntMultiSelect {
        width: 200
        suffix: 'User'
        options: [
            { value: 'jack', label: 'Jack' },
            { value: 'lucy', label: 'Lucy' },
            { value: 'David', label: 'david' },
            { value: 'disabled', label: 'Disabled', disabled: true },
        ]
    }

    AntMultiSelect {
        width: 200
        suffixDelegate: AntIconText { iconSource: AntIcon.SmileOutlined }
        options: [
            { value: 'jack', label: 'Jack' },
            { value: 'lucy', label: 'Lucy' },
            { value: 'David', label: 'david' },
            { value: 'disabled', label: 'Disabled', disabled: true },
        ]
    }
}
            `
            exampleDelegate: Column {
                spacing: 10

                Row {
                    spacing: 10

                    AntMultiSelect {
                        width: 200
                        prefix: 'User'
                        options: [
                            { value: 'jack', label: 'Jack' },
                            { value: 'lucy', label: 'Lucy' },
                            { value: 'David', label: 'david' },
                            { value: 'disabled', label: 'Disabled', disabled: true },
                        ]
                    }

                    AntMultiSelect {
                        width: 200
                        suffix: 'User'
                        options: [
                            { value: 'jack', label: 'Jack' },
                            { value: 'lucy', label: 'Lucy' },
                            { value: 'David', label: 'david' },
                            { value: 'disabled', label: 'Disabled', disabled: true },
                        ]
                    }
                }

                Row {
                    spacing: 10

                    AntMultiSelect {
                        width: 200
                        prefixDelegate: AntIconText { iconSource: AntIcon.SmileOutlined }
                        options: [
                            { value: 'jack', label: 'Jack' },
                            { value: 'lucy', label: 'Lucy' },
                            { value: 'David', label: 'david' },
                            { value: 'disabled', label: 'Disabled', disabled: true },
                        ]
                    }

                    AntMultiSelect {
                        width: 200
                        suffixDelegate: AntIconText { iconSource: AntIcon.SmileOutlined }
                        options: [
                            { value: 'jack', label: 'Jack' },
                            { value: 'lucy', label: 'Lucy' },
                            { value: 'David', label: 'david' },
                            { value: 'disabled', label: 'Disabled', disabled: true },
                        ]
                    }
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr(`隐藏已选择选项`)
            desc: qsTr(`
隐藏下拉列表中已选择的选项。\n
                       `)
            code: `
import QtQuick
import Antilla.Basic

AntMultiSelect {
    width: 500
    filterOption:
        (input, option) => {
            filteredOptions = theOptions.filter((o) => !selectedKeys.includes(o));
            return filteredOptions.indexOf(option.label) != -1;
        }
    onSelected: {
        filteredOptions = theOptions.filter((o) => !selectedKeys.includes(o));
        options = filteredOptions.map((item) => ({ label: item }));
    }
    onTagRemoved: {
        filteredOptions = theOptions.filter((o) => !selectedKeys.includes(o));
        options = filteredOptions.map((item) => ({ label: item }));
    }
    Component.onCompleted: options = theOptions.map((item) => ({ label: item }));
    property var theOptions: ['Apples', 'Nails', 'Bananas', 'Helicopters']
    property var filteredOptions: []
}
            `
            exampleDelegate: Row {
                spacing: 10

                AntMultiSelect {
                    width: 500
                    filterOption:
                        (input, option) => {
                            filteredOptions = theOptions.filter((o) => !selectedKeys.includes(o));
                            return filteredOptions.indexOf(option.label) !== -1;
                        }
                    onSelected: {
                        filteredOptions = theOptions.filter((o) => !selectedKeys.includes(o));
                        options = filteredOptions.map((item) => ({ label: item }));
                    }
                    onTagRemoved: {
                        filteredOptions = theOptions.filter((o) => !selectedKeys.includes(o));
                        options = filteredOptions.map((item) => ({ label: item }));
                    }
                    Component.onCompleted: options = theOptions.map((item) => ({ label: item }));
                    property var theOptions: ['Apples', 'Nails', 'Bananas', 'Helicopters']
                    property var filteredOptions: []
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr(`自定义选择标签`)
            desc: qsTr(`
允许自定义选择标签的样式。\n
通过 \`tagDelegate\` 设置标签代理。\n
                       `)
            code: `
import QtQuick
import Antilla.Basic

AntMultiSelect {
    id: customTag
    width: 500
    tagDelegate: AntTag {
        text: tagData.label
        adjustHeight: 2
        presetColor: tagData.value
        closeIconSource: AntIcon.CloseOutlined
        closeIconSize: 12
        onClosed: customTag.removeTagAtIndex(index);
    }
    options: [
        { label: 'gold', value: 'gold' },
        { label: 'lime', value: 'lime' },
        { label: 'green', value: 'green' },
        { label: 'cyan', value: 'cyan' },
    ]
}
            `
            exampleDelegate: Row {
                spacing: 10

                AntMultiSelect {
                    id: customTag
                    width: 500
                    tagDelegate: AntTag {
                        text: tagData.label
                        adjustHeight: 2
                        presetColor: tagData.value
                        closeIconSource: AntIcon.CloseOutlined
                        closeIconSize: 12
                        onClosed: customTag.removeTagAtIndex(index);
                    }
                    options: [
                        { label: 'gold', value: 'gold' },
                        { label: 'lime', value: 'lime' },
                        { label: 'green', value: 'green' },
                        { label: 'cyan', value: 'cyan' },
                    ]
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr(`最大选中数量`)
            desc: qsTr(`
通过设置 \`maxTagCount\` 约束最多可选中的数量，当超出限制时会变成禁止选中状态。\n
                       `)
            code: `
import QtQuick
import Antilla.Basic

AntMultiSelect {
    width: 500
    maxTagCount: 3
    suffix: \`\${tagCount}/\${maxTagCount}\`
    options: [
        { value: 'Ava Swift', label: 'Ava Swift' },
        { value: 'Cole Reed', label: 'Cole Reed' },
        { value: 'Mia Blake', label: 'Mia Blake' },
        { value: 'Jake Stone', label: 'Jake Stone' },
        { value: 'Lily Lane', label: 'Lily Lane' },
        { value: 'Ryan Chase', label: 'Ryan Chase' },
        { value: 'Zoe Fox', label: 'Zoe Fox' },
        { value: 'Alex Grey', label: 'Alex Grey' },
        { value: 'Elle Blair', label: 'Elle Blair' },
    ]
}
            `
            exampleDelegate: Row {
                spacing: 10

                AntMultiSelect {
                    width: 500
                    maxTagCount: 3
                    suffix: `${tagCount}/${maxTagCount}`
                    options: [
                        { value: 'Ava Swift', label: 'Ava Swift' },
                        { value: 'Cole Reed', label: 'Cole Reed' },
                        { value: 'Mia Blake', label: 'Mia Blake' },
                        { value: 'Jake Stone', label: 'Jake Stone' },
                        { value: 'Lily Lane', label: 'Lily Lane' },
                        { value: 'Ryan Chase', label: 'Ryan Chase' },
                        { value: 'Zoe Fox', label: 'Zoe Fox' },
                        { value: 'Alex Grey', label: 'Alex Grey' },
                        { value: 'Elle Blair', label: 'Elle Blair' },
                    ]
                }
            }
        }

        CodeBox {
            width: parent.width
            descTitle: qsTr(`大数据`)
            desc: qsTr(`
100000 选择项。\n
                       `)
            code: `
import QtQuick
import Antilla.Basic

Loader {
    asynchronous: true
    sourceComponent: AntMultiSelect {
        width: 500
        genDefaultKey: false
        filterOption: (input, option) => option.label.toUpperCase().indexOf(input.toUpperCase()) !== -1
        Component.onCompleted: {
            const list = [];
            for (let i = 0; i < 100000; i++) {
                const label = \`\${i.toString(36)}\${i}\`;
                list.push({ key: label, label: label, disabled: i === 10 });
            }
            options = list;
        }
    }
}
            `
            exampleDelegate: Row {
                spacing: 10

                Loader {
                    asynchronous: true
                    sourceComponent: AntMultiSelect {
                        width: 500
                        genDefaultKey: false
                        filterOption: (input, option) => option.label.toUpperCase().indexOf(input.toUpperCase()) !== -1
                        Component.onCompleted: {
                            const list = [];
                            for (let i = 0; i < 100000; i++) {
                                const label = `${i.toString(36)}${i}`;
                                list.push({ key: label, label: label, disabled: i === 10 });
                            }
                            options = list;
                        }
                    }
                }
            }
        }
    }
}
