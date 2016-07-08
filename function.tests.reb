REBOL [
        Purpose: {Play around with function composition in Ren-C.}
]

do %../reb/env.reb

script-needs [
        %requirements.reb
]

requirements 'frame [

        [
                frame: make frame! :append
                frame/series: [a b c]
                frame/value: 'd
                do frame
                frame/value: 'e 
                [a b c d e] = do frame
        ]
]

specialize-tests: requirements 'specialize [

        [
                f: function [x] [x]
                g: specialize 'f [x: 1]
                1 = g
        ]

]

adapt-tests: requirements 'adapt [

        [
                f: function [x] [x * 2]
                g: adapt 'f [x: x + 1]
                4 = g 1
        ]
]

hijack-tests: requirements 'hijack [

        [
                f: function [x] [x]
                f2: :f
                g: function [x] [x * 2]
                h: hijack 'f 'g
                all [4 = (f 2) 4 = (f2 2)]
        ]

        [
                i: hijack 'f _
                4 = i 2
        ]
]

chain-tests: requirements 'chain [

        [
                f: function [x] [x * 2]
                g: chain [:f :f :f]
                8 = g 1
        ]
]

print mold requirements %function-composition-tests.reb [

        [[specialize passed] = specialize-tests]
        [[adapt passed] = adapt-tests]
        [[hijack passed] = hijack-tests]
        [[chain passed] = chain-tests]
]


HALT