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
# AntAsyncHasher 异步散列器\n
可对任意数据(url/text/object)生成加密哈希的异步散列器。\n
* **继承自 { QObject }**\n
\n<br/>
\n### 支持的属性：\n
属性名 | 类型 | 默认值 | 描述
------ | --- | :---: | ---
algorithm | enum | AntAsyncHasher.Md5 | 哈希算法(来自 AntAsyncHasher)
asynchronous | bool | true | 是否异步
hashValue | string | '' | 目标的哈希值
hashLength | int | - | 目标的哈希长度
source | url | '' | 目标的源地址
sourceText | color | '' | 目标的源文本
sourceData | arraybuffer | '' | 目标的源数据
sourceObject | QObject* | null | 目标的源指针
                       `)
        }

        Description {
            title: qsTr('何时使用')
            desc: qsTr(`
当需要对(url/text/object)生成加密哈希时使用。\n
                       `)
        }

        Description {
            title: qsTr('代码演示')
        }

        CodeBox {
            width: parent.width
            desc: qsTr(`
通过 \`algorithm\` 属性改变使用的哈希算法，支持的算法：\n
- Md4{ AntAsyncHasher.Md4 }\n
- Md5(默认){ AntAsyncHasher.Md5 }\n
- Sha1{ AntAsyncHasher.Sha1 }\n
- Sha224{ AntAsyncHasher.Sha224 }\n
- Sha256{ AntAsyncHasher.Sha256 }\n
- Sha384{ AntAsyncHasher.Sha384 }\n
- Sha512{ AntAsyncHasher.Sha512 }\n
- Keccak_224{ AntAsyncHasher.Keccak_224 }\n
- Keccak_256{ AntAsyncHasher.Keccak_256 }\n
- Keccak_384{ AntAsyncHasher.Keccak_384 }\n
- Keccak_512{ AntAsyncHasher.Keccak_512 }\n
- RealSha3_224{ AntAsyncHasher.RealSha3_224 }\n
- RealSha3_256{ AntAsyncHasher.RealSha3_256 }\n
- RealSha3_384{ AntAsyncHasher.RealSha3_384 }\n
- RealSha3_512{ AntAsyncHasher.RealSha3_512 }\n
- Sha3_224{ AntAsyncHasher.Sha3_224 }\n
- Sha3_256{ AntAsyncHasher.Sha3_256 }\n
- Sha3_384{ AntAsyncHasher.Sha3_384 }\n
- Sha3_512{ AntAsyncHasher.Sha3_512 }\n
- Blake2b_160{ AntAsyncHasher.Blake2b_160 }\n
- Blake2b_256{ AntAsyncHasher.Blake2b_256 }\n
- Blake2b_384{ AntAsyncHasher.Blake2b_384 }\n
- Blake2b_512{ AntAsyncHasher.Blake2b_512 }\n
- Blake2s_128{ AntAsyncHasher.Blake2s_128 }\n
- Blake2s_160{ AntAsyncHasher.Blake2s_160 }\n
- Blake2s_224{ AntAsyncHasher.Blake2s_224 }\n
- Blake2s_256{ AntAsyncHasher.Blake2s_256 }\n
通过 \`sourceText\` 属性设置需要进行哈希计算的目标源文本。\n
                       `)
            code: `
import QtQuick
import Antilla.Basic

Column {
    AntCopyableText {
        text: '[Source] ' + hasher.sourceText
    }

    AntCopyableText {
        text: '[Result] ' + hasher.hashValue
    }

    AntAsyncHasher {
        id: hasher
        algorithm: AntAsyncHasher.Md5
        sourceText: 'Antilla'
    }
}
            `
            exampleDelegate: Column {
                AntCopyableText {
                    text: '[Source] ' + hasher.sourceText
                }

                AntCopyableText {
                    text: '[Result] ' + hasher.hashValue
                }

                AntAsyncHasher {
                    id: hasher
                    algorithm: AntAsyncHasher.Md5
                    sourceText: 'Antilla'
                }
            }
        }
    }
}
