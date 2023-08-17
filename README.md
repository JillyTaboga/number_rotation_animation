# number_rotation_animation

Um estudo em flutter para a implementação da animação de valores numéricos do Xcode 15 com a SwiftUi vista nesse tweet <https://twitter.com/jsedlacekjr/status/1691153051556462592> e ventilada pelo <https://twitter.com/devangelslondon> na live de Flutter <https://www.youtube.com/watch?v=fOzhbsb6W7M&ab_channel=FlutterCommunity>

A ideia é criar uma animação onde os números dão a impressão de estarem sendo substituidos verticalmente na direção do próximo digito, algo semelhante a placas numéricas antigas, era importante criar a ilusão de aumento ou diminuição indicando de onde estão vindo as alterações de cima ou de baixo

Para transforma essa animação em um package de produção teria que ser ampliada a API para tratar formatações numéricas diferenciadas, possivelmente utilizando um NumberFormat do intl como parâmetro.
