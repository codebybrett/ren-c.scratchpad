REBOL []

;
; Needs c-lexicals.r

tokenise-c: function [
    {Tokenise C source text.}
    source-text [string!]
][

    rule: bind [

        opt [bot: skip :bot (line: 1)]

        any [

            bot: [

                eol eot: (
                    token: 'eol
                    emit
                    line: line + 1
                )

                | wsp eot: (token: 'wsp emit)

                | [
                    nl (token: 'nl)
                    | span-comment (token: 'span-comment)
                    | line-comment (token: 'line-comment)
                    | pp-number (token: 'pp-number)
                    | character-constant (token: 'character-constant)
                    | identifier (token: 'identifier)
                    | string-literal (token: 'string-literal)
                    | header-name (token: 'header-name)
                    | punctuator (token: 'punctuator)
                    | other-pp-token (token: 'other-pp-token)

                ] eot: (emit)
            ]
        ]

        eot: (token: 'end emit)

    ] c.lexical/grammar

    emit: function [][
        append tokens reduce [index? bot token copy/part bot eot]
    ]

    tokens: make block! divide length source-text 5

    either parse source-text rule [
        return tokens
    ][
        fail {Could not tokenise c.}
    ]
]