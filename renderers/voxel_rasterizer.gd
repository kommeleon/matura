extends Node2D

var plane_001 = [
	[Vector3(-16.5296, 0.0000, 15.1689), Vector3(15.4704, 0.0000, 15.1689), Vector3(15.4704, 2.0000, 15.1689)],  [Vector3(-16.5296, 0.0000, 15.1689), Vector3(15.4704, 2.0000, 15.1689), Vector3(-16.5296, 2.0000, 15.1689)]
]
var plane = [
	[Vector3(-16.5296, 0.0000, -13.8311), Vector3(15.4704, 0.0000, -13.8311), Vector3(15.4704, 0.0000, 50.1689)],  [Vector3(-16.5296, 0.0000, -13.8311), Vector3(15.4704, 0.0000, 50.1689), Vector3(-16.5296, 0.0000, 50.1689)]
]
var ziel_1 = [
	[Vector3(-0.6988, 0.0030, 21.2529), Vector3(-0.6988, 5.0770, 21.2529), Vector3(-0.6988, 5.0770, 21.5912)],  [Vector3(-0.6988, 0.0030, 21.2529), Vector3(-0.6988, 5.0770, 21.5912), Vector3(-0.6988, 0.0030, 21.5912)],  [Vector3(-0.6988, 0.0030, 21.5912), Vector3(-0.6988, 5.0770, 21.5912), Vector3(-0.3605, 5.0770, 21.5912)],  [Vector3(-0.6988, 0.0030, 21.5912), Vector3(-0.3605, 5.0770, 21.5912), Vector3(-0.3605, 0.0030, 21.5912)],  [Vector3(-0.3605, 0.0030, 21.5912), Vector3(-0.3605, 5.0770, 21.5912), Vector3(-0.3605, 5.0770, 21.2529)],  [Vector3(-0.3605, 0.0030, 21.5912), Vector3(-0.3605, 5.0770, 21.2529), Vector3(-0.3605, 0.0030, 21.2529)],  [Vector3(-0.3605, 0.0030, 21.2529), Vector3(-0.3605, 5.0770, 21.2529), Vector3(-0.6988, 5.0770, 21.2529)],  [Vector3(-0.3605, 0.0030, 21.2529), Vector3(-0.6988, 5.0770, 21.2529), Vector3(-0.6988, 0.0030, 21.2529)],  [Vector3(-0.6988, 0.0030, 21.5912), Vector3(-0.3605, 0.0030, 21.5912), Vector3(-0.3605, 0.0030, 21.2529)],  [Vector3(-0.6988, 0.0030, 21.5912), Vector3(-0.3605, 0.0030, 21.2529), Vector3(-0.6988, 0.0030, 21.2529)],  [Vector3(-0.3605, 5.0770, 21.5912), Vector3(-0.6988, 5.0770, 21.5912), Vector3(-0.6988, 5.0770, 21.2529)],  [Vector3(-0.3605, 5.0770, 21.5912), Vector3(-0.6988, 5.0770, 21.2529), Vector3(-0.3605, 5.0770, 21.2529)],  [Vector3(-1.5296, 2.8000, 21.0121), Vector3(-1.5296, 4.8000, 21.0121), Vector3(-1.5296, 4.8000, 21.2964)],  [Vector3(-1.5296, 2.8000, 21.0121), Vector3(-1.5296, 4.8000, 21.2964), Vector3(-1.5296, 2.8000, 21.2964)],  [Vector3(-1.5296, 2.8000, 21.2964), Vector3(-1.5296, 4.8000, 21.2964), Vector3(0.4704, 4.8000, 21.2964)],  [Vector3(-1.5296, 2.8000, 21.2964), Vector3(0.4704, 4.8000, 21.2964), Vector3(0.4704, 2.8000, 21.2964)],  [Vector3(0.4704, 2.8000, 21.2964), Vector3(0.4704, 4.8000, 21.2964), Vector3(0.4704, 4.8000, 21.0121)],  [Vector3(0.4704, 2.8000, 21.2964), Vector3(0.4704, 4.8000, 21.0121), Vector3(0.4704, 2.8000, 21.0121)],  [Vector3(0.4704, 2.8000, 21.0121), Vector3(-0.5296, 3.8000, 21.0121), Vector3(-1.5296, 2.8000, 21.0121)],  [Vector3(-1.5296, 2.8000, 21.2964), Vector3(0.4704, 2.8000, 21.2964), Vector3(0.4704, 2.8000, 21.0121)],  [Vector3(-1.5296, 2.8000, 21.2964), Vector3(0.4704, 2.8000, 21.0121), Vector3(-1.5296, 2.8000, 21.0121)],  [Vector3(0.4704, 4.8000, 21.2964), Vector3(-1.5296, 4.8000, 21.2964), Vector3(-1.5296, 4.8000, 21.0121)],  [Vector3(0.4704, 4.8000, 21.2964), Vector3(-1.5296, 4.8000, 21.0121), Vector3(0.4704, 4.8000, 21.0121)],  [Vector3(-1.5296, 2.8000, 21.0121), Vector3(-0.5296, 3.8000, 21.0121), Vector3(-1.5296, 4.8000, 21.0121)],  [Vector3(-1.5296, 4.8000, 21.0121), Vector3(-0.5296, 3.8000, 21.0121), Vector3(0.4704, 4.8000, 21.0121)],  [Vector3(-0.5296, 3.8000, 21.0121), Vector3(0.4704, 2.8000, 21.0121), Vector3(0.4704, 4.8000, 21.0121)]
]
var ziel_2 = [
	[Vector3(-0.6988, 0.0030, 29.1571), Vector3(-0.6988, 5.0770, 29.1571), Vector3(-0.6988, 5.0770, 29.4953)],  [Vector3(-0.6988, 0.0030, 29.1571), Vector3(-0.6988, 5.0770, 29.4953), Vector3(-0.6988, 0.0030, 29.4953)],  [Vector3(-0.6988, 0.0030, 29.4953), Vector3(-0.6988, 5.0770, 29.4953), Vector3(-0.3605, 5.0770, 29.4953)],  [Vector3(-0.6988, 0.0030, 29.4953), Vector3(-0.3605, 5.0770, 29.4953), Vector3(-0.3605, 0.0030, 29.4953)],  [Vector3(-0.3605, 0.0030, 29.4953), Vector3(-0.3605, 5.0770, 29.4953), Vector3(-0.3605, 5.0770, 29.1571)],  [Vector3(-0.3605, 0.0030, 29.4953), Vector3(-0.3605, 5.0770, 29.1571), Vector3(-0.3605, 0.0030, 29.1571)],  [Vector3(-0.3605, 0.0030, 29.1571), Vector3(-0.3605, 5.0770, 29.1571), Vector3(-0.6988, 5.0770, 29.1571)],  [Vector3(-0.3605, 0.0030, 29.1571), Vector3(-0.6988, 5.0770, 29.1571), Vector3(-0.6988, 0.0030, 29.1571)],  [Vector3(-0.6988, 0.0030, 29.4953), Vector3(-0.3605, 0.0030, 29.4953), Vector3(-0.3605, 0.0030, 29.1571)],  [Vector3(-0.6988, 0.0030, 29.4953), Vector3(-0.3605, 0.0030, 29.1571), Vector3(-0.6988, 0.0030, 29.1571)],  [Vector3(-0.3605, 5.0770, 29.4953), Vector3(-0.6988, 5.0770, 29.4953), Vector3(-0.6988, 5.0770, 29.1571)],  [Vector3(-0.3605, 5.0770, 29.4953), Vector3(-0.6988, 5.0770, 29.1571), Vector3(-0.3605, 5.0770, 29.1571)],  [Vector3(-1.5296, 2.8000, 28.9162), Vector3(-1.5296, 4.8000, 28.9162), Vector3(-1.5296, 4.8000, 29.2006)],  [Vector3(-1.5296, 2.8000, 28.9162), Vector3(-1.5296, 4.8000, 29.2006), Vector3(-1.5296, 2.8000, 29.2006)],  [Vector3(-1.5296, 2.8000, 29.2006), Vector3(-1.5296, 4.8000, 29.2006), Vector3(0.4704, 4.8000, 29.2006)],  [Vector3(-1.5296, 2.8000, 29.2006), Vector3(0.4704, 4.8000, 29.2006), Vector3(0.4704, 2.8000, 29.2006)],  [Vector3(0.4704, 2.8000, 29.2006), Vector3(0.4704, 4.8000, 29.2006), Vector3(0.4704, 4.8000, 28.9162)],  [Vector3(0.4704, 2.8000, 29.2006), Vector3(0.4704, 4.8000, 28.9162), Vector3(0.4704, 2.8000, 28.9162)],  [Vector3(0.4704, 2.8000, 28.9162), Vector3(-0.5296, 3.8000, 28.9162), Vector3(-1.5296, 2.8000, 28.9162)],  [Vector3(-1.5296, 2.8000, 29.2006), Vector3(0.4704, 2.8000, 29.2006), Vector3(0.4704, 2.8000, 28.9162)],  [Vector3(-1.5296, 2.8000, 29.2006), Vector3(0.4704, 2.8000, 28.9162), Vector3(-1.5296, 2.8000, 28.9162)],  [Vector3(0.4704, 4.8000, 29.2006), Vector3(-1.5296, 4.8000, 29.2006), Vector3(-1.5296, 4.8000, 28.9162)],  [Vector3(0.4704, 4.8000, 29.2006), Vector3(-1.5296, 4.8000, 28.9162), Vector3(0.4704, 4.8000, 28.9162)],  [Vector3(-1.5296, 2.8000, 28.9162), Vector3(-0.5296, 3.8000, 28.9162), Vector3(-1.5296, 4.8000, 28.9162)],  [Vector3(-1.5296, 4.8000, 28.9162), Vector3(-0.5296, 3.8000, 28.9162), Vector3(0.4704, 4.8000, 28.9162)],  [Vector3(-0.5296, 3.8000, 28.9162), Vector3(0.4704, 2.8000, 28.9162), Vector3(0.4704, 4.8000, 28.9162)]
]
var ziel_3 = [
	[Vector3(-0.6988, 0.0030, 35.4524), Vector3(-0.6988, 5.0770, 35.4524), Vector3(-0.6988, 5.0770, 35.7907)],  [Vector3(-0.6988, 0.0030, 35.4524), Vector3(-0.6988, 5.0770, 35.7907), Vector3(-0.6988, 0.0030, 35.7907)],  [Vector3(-0.6988, 0.0030, 35.7907), Vector3(-0.6988, 5.0770, 35.7907), Vector3(-0.3605, 5.0770, 35.7907)],  [Vector3(-0.6988, 0.0030, 35.7907), Vector3(-0.3605, 5.0770, 35.7907), Vector3(-0.3605, 0.0030, 35.7907)],  [Vector3(-0.3605, 0.0030, 35.7907), Vector3(-0.3605, 5.0770, 35.7907), Vector3(-0.3605, 5.0770, 35.4524)],  [Vector3(-0.3605, 0.0030, 35.7907), Vector3(-0.3605, 5.0770, 35.4524), Vector3(-0.3605, 0.0030, 35.4524)],  [Vector3(-0.3605, 0.0030, 35.4524), Vector3(-0.3605, 5.0770, 35.4524), Vector3(-0.6988, 5.0770, 35.4524)],  [Vector3(-0.3605, 0.0030, 35.4524), Vector3(-0.6988, 5.0770, 35.4524), Vector3(-0.6988, 0.0030, 35.4524)],  [Vector3(-0.6988, 0.0030, 35.7907), Vector3(-0.3605, 0.0030, 35.7907), Vector3(-0.3605, 0.0030, 35.4524)],  [Vector3(-0.6988, 0.0030, 35.7907), Vector3(-0.3605, 0.0030, 35.4524), Vector3(-0.6988, 0.0030, 35.4524)],  [Vector3(-0.3605, 5.0770, 35.7907), Vector3(-0.6988, 5.0770, 35.7907), Vector3(-0.6988, 5.0770, 35.4524)],  [Vector3(-0.3605, 5.0770, 35.7907), Vector3(-0.6988, 5.0770, 35.4524), Vector3(-0.3605, 5.0770, 35.4524)],  [Vector3(-1.5296, 2.8000, 35.2116), Vector3(-1.5296, 4.8000, 35.2116), Vector3(-1.5296, 4.8000, 35.4959)],  [Vector3(-1.5296, 2.8000, 35.2116), Vector3(-1.5296, 4.8000, 35.4959), Vector3(-1.5296, 2.8000, 35.4959)],  [Vector3(-1.5296, 2.8000, 35.4959), Vector3(-1.5296, 4.8000, 35.4959), Vector3(0.4704, 4.8000, 35.4959)],  [Vector3(-1.5296, 2.8000, 35.4959), Vector3(0.4704, 4.8000, 35.4959), Vector3(0.4704, 2.8000, 35.4959)],  [Vector3(0.4704, 2.8000, 35.4959), Vector3(0.4704, 4.8000, 35.4959), Vector3(0.4704, 4.8000, 35.2116)],  [Vector3(0.4704, 2.8000, 35.4959), Vector3(0.4704, 4.8000, 35.2116), Vector3(0.4704, 2.8000, 35.2116)],  [Vector3(0.4704, 2.8000, 35.2116), Vector3(-0.5296, 3.8000, 35.2116), Vector3(-1.5296, 2.8000, 35.2116)],  [Vector3(-1.5296, 2.8000, 35.4959), Vector3(0.4704, 2.8000, 35.4959), Vector3(0.4704, 2.8000, 35.2116)],  [Vector3(-1.5296, 2.8000, 35.4959), Vector3(0.4704, 2.8000, 35.2116), Vector3(-1.5296, 2.8000, 35.2116)],  [Vector3(0.4704, 4.8000, 35.4959), Vector3(-1.5296, 4.8000, 35.4959), Vector3(-1.5296, 4.8000, 35.2116)],  [Vector3(0.4704, 4.8000, 35.4959), Vector3(-1.5296, 4.8000, 35.2116), Vector3(0.4704, 4.8000, 35.2116)],  [Vector3(-1.5296, 2.8000, 35.2116), Vector3(-0.5296, 3.8000, 35.2116), Vector3(-1.5296, 4.8000, 35.2116)],  [Vector3(-1.5296, 4.8000, 35.2116), Vector3(-0.5296, 3.8000, 35.2116), Vector3(0.4704, 4.8000, 35.2116)],  [Vector3(-0.5296, 3.8000, 35.2116), Vector3(0.4704, 2.8000, 35.2116), Vector3(0.4704, 4.8000, 35.2116)]
]
var ziel_4 = [
	[Vector3(-0.6988, 0.0030, 40.5056), Vector3(-0.6988, 5.0770, 40.5056), Vector3(-0.6988, 5.0770, 40.8438)],  [Vector3(-0.6988, 0.0030, 40.5056), Vector3(-0.6988, 5.0770, 40.8438), Vector3(-0.6988, 0.0030, 40.8438)],  [Vector3(-0.6988, 0.0030, 40.8438), Vector3(-0.6988, 5.0770, 40.8438), Vector3(-0.3605, 5.0770, 40.8438)],  [Vector3(-0.6988, 0.0030, 40.8438), Vector3(-0.3605, 5.0770, 40.8438), Vector3(-0.3605, 0.0030, 40.8438)],  [Vector3(-0.3605, 0.0030, 40.8438), Vector3(-0.3605, 5.0770, 40.8438), Vector3(-0.3605, 5.0770, 40.5056)],  [Vector3(-0.3605, 0.0030, 40.8438), Vector3(-0.3605, 5.0770, 40.5056), Vector3(-0.3605, 0.0030, 40.5056)],  [Vector3(-0.3605, 0.0030, 40.5056), Vector3(-0.3605, 5.0770, 40.5056), Vector3(-0.6988, 5.0770, 40.5056)],  [Vector3(-0.3605, 0.0030, 40.5056), Vector3(-0.6988, 5.0770, 40.5056), Vector3(-0.6988, 0.0030, 40.5056)],  [Vector3(-0.6988, 0.0030, 40.8438), Vector3(-0.3605, 0.0030, 40.8438), Vector3(-0.3605, 0.0030, 40.5056)],  [Vector3(-0.6988, 0.0030, 40.8438), Vector3(-0.3605, 0.0030, 40.5056), Vector3(-0.6988, 0.0030, 40.5056)],  [Vector3(-0.3605, 5.0770, 40.8438), Vector3(-0.6988, 5.0770, 40.8438), Vector3(-0.6988, 5.0770, 40.5056)],  [Vector3(-0.3605, 5.0770, 40.8438), Vector3(-0.6988, 5.0770, 40.5056), Vector3(-0.3605, 5.0770, 40.5056)],  [Vector3(-1.5296, 2.8000, 40.2647), Vector3(-1.5296, 4.8000, 40.2647), Vector3(-1.5296, 4.8000, 40.5491)],  [Vector3(-1.5296, 2.8000, 40.2647), Vector3(-1.5296, 4.8000, 40.5491), Vector3(-1.5296, 2.8000, 40.5491)],  [Vector3(-1.5296, 2.8000, 40.5491), Vector3(-1.5296, 4.8000, 40.5491), Vector3(0.4704, 4.8000, 40.5491)],  [Vector3(-1.5296, 2.8000, 40.5491), Vector3(0.4704, 4.8000, 40.5491), Vector3(0.4704, 2.8000, 40.5491)],  [Vector3(0.4704, 2.8000, 40.5491), Vector3(0.4704, 4.8000, 40.5491), Vector3(0.4704, 4.8000, 40.2647)],  [Vector3(0.4704, 2.8000, 40.5491), Vector3(0.4704, 4.8000, 40.2647), Vector3(0.4704, 2.8000, 40.2647)],  [Vector3(0.4704, 2.8000, 40.2647), Vector3(-0.5296, 3.8000, 40.2647), Vector3(-1.5296, 2.8000, 40.2647)],  [Vector3(-1.5296, 2.8000, 40.5491), Vector3(0.4704, 2.8000, 40.5491), Vector3(0.4704, 2.8000, 40.2647)],  [Vector3(-1.5296, 2.8000, 40.5491), Vector3(0.4704, 2.8000, 40.2647), Vector3(-1.5296, 2.8000, 40.2647)],  [Vector3(0.4704, 4.8000, 40.5491), Vector3(-1.5296, 4.8000, 40.5491), Vector3(-1.5296, 4.8000, 40.2647)],  [Vector3(0.4704, 4.8000, 40.5491), Vector3(-1.5296, 4.8000, 40.2647), Vector3(0.4704, 4.8000, 40.2647)],  [Vector3(-1.5296, 2.8000, 40.2647), Vector3(-0.5296, 3.8000, 40.2647), Vector3(-1.5296, 4.8000, 40.2647)],  [Vector3(-1.5296, 4.8000, 40.2647), Vector3(-0.5296, 3.8000, 40.2647), Vector3(0.4704, 4.8000, 40.2647)],  [Vector3(-0.5296, 3.8000, 40.2647), Vector3(0.4704, 2.8000, 40.2647), Vector3(0.4704, 4.8000, 40.2647)]
]
var ziel_5 = [
	[Vector3(-0.8851, 0.0030, 44.9307), Vector3(-0.8851, 5.0770, 44.9307), Vector3(-0.8851, 5.0770, 45.2690)],  [Vector3(-0.8851, 0.0030, 44.9307), Vector3(-0.8851, 5.0770, 45.2690), Vector3(-0.8851, 0.0030, 45.2690)],  [Vector3(-0.8851, 0.0030, 45.2690), Vector3(-0.8851, 5.0770, 45.2690), Vector3(-0.5468, 5.0770, 45.2690)],  [Vector3(-0.8851, 0.0030, 45.2690), Vector3(-0.5468, 5.0770, 45.2690), Vector3(-0.5468, 0.0030, 45.2690)],  [Vector3(-0.5468, 0.0030, 45.2690), Vector3(-0.5468, 5.0770, 45.2690), Vector3(-0.5468, 5.0770, 44.9307)],  [Vector3(-0.5468, 0.0030, 45.2690), Vector3(-0.5468, 5.0770, 44.9307), Vector3(-0.5468, 0.0030, 44.9307)],  [Vector3(-0.5468, 0.0030, 44.9307), Vector3(-0.5468, 5.0770, 44.9307), Vector3(-0.8851, 5.0770, 44.9307)],  [Vector3(-0.5468, 0.0030, 44.9307), Vector3(-0.8851, 5.0770, 44.9307), Vector3(-0.8851, 0.0030, 44.9307)],  [Vector3(-0.8851, 0.0030, 45.2690), Vector3(-0.5468, 0.0030, 45.2690), Vector3(-0.5468, 0.0030, 44.9307)],  [Vector3(-0.8851, 0.0030, 45.2690), Vector3(-0.5468, 0.0030, 44.9307), Vector3(-0.8851, 0.0030, 44.9307)],  [Vector3(-0.5468, 5.0770, 45.2690), Vector3(-0.8851, 5.0770, 45.2690), Vector3(-0.8851, 5.0770, 44.9307)],  [Vector3(-0.5468, 5.0770, 45.2690), Vector3(-0.8851, 5.0770, 44.9307), Vector3(-0.5468, 5.0770, 44.9307)],  [Vector3(-1.7159, 2.8000, 44.6899), Vector3(-1.7159, 4.8000, 44.6899), Vector3(-1.7159, 4.8000, 44.9743)],  [Vector3(-1.7159, 2.8000, 44.6899), Vector3(-1.7159, 4.8000, 44.9743), Vector3(-1.7159, 2.8000, 44.9743)],  [Vector3(-1.7159, 2.8000, 44.9743), Vector3(-1.7159, 4.8000, 44.9743), Vector3(0.2841, 4.8000, 44.9743)],  [Vector3(-1.7159, 2.8000, 44.9743), Vector3(0.2841, 4.8000, 44.9743), Vector3(0.2841, 2.8000, 44.9743)],  [Vector3(0.2841, 2.8000, 44.9743), Vector3(0.2841, 4.8000, 44.9743), Vector3(0.2841, 4.8000, 44.6899)],  [Vector3(0.2841, 2.8000, 44.9743), Vector3(0.2841, 4.8000, 44.6899), Vector3(0.2841, 2.8000, 44.6899)],  [Vector3(0.2841, 2.8000, 44.6899), Vector3(-0.7159, 3.8000, 44.6899), Vector3(-1.7159, 2.8000, 44.6899)],  [Vector3(-1.7159, 2.8000, 44.9743), Vector3(0.2841, 2.8000, 44.9743), Vector3(0.2841, 2.8000, 44.6899)],  [Vector3(-1.7159, 2.8000, 44.9743), Vector3(0.2841, 2.8000, 44.6899), Vector3(-1.7159, 2.8000, 44.6899)],  [Vector3(0.2841, 4.8000, 44.9743), Vector3(-1.7159, 4.8000, 44.9743), Vector3(-1.7159, 4.8000, 44.6899)],  [Vector3(0.2841, 4.8000, 44.9743), Vector3(-1.7159, 4.8000, 44.6899), Vector3(0.2841, 4.8000, 44.6899)],  [Vector3(-1.7159, 2.8000, 44.6899), Vector3(-0.7159, 3.8000, 44.6899), Vector3(-1.7159, 4.8000, 44.6899)],  [Vector3(-1.7159, 4.8000, 44.6899), Vector3(-0.7159, 3.8000, 44.6899), Vector3(0.2841, 4.8000, 44.6899)],  [Vector3(-0.7159, 3.8000, 44.6899), Vector3(0.2841, 2.8000, 44.6899), Vector3(0.2841, 4.8000, 44.6899)]
]
var plane_002 = [
	[Vector3(-16.5296, 0.0000, -13.8311), Vector3(-16.5296, 9.6000, -13.8311), Vector3(-16.5296, 9.6000, 50.1689)],  [Vector3(-16.5296, 0.0000, -13.8311), Vector3(-16.5296, 9.6000, 50.1689), Vector3(-16.5296, 0.0000, 50.1689)]
]
var plane_003 = [
	[Vector3(15.4704, 0.0000, -13.8311), Vector3(15.4704, 9.6000, -13.8311), Vector3(15.4704, 9.6000, 50.1689)],  [Vector3(15.4704, 0.0000, -13.8311), Vector3(15.4704, 9.6000, 50.1689), Vector3(15.4704, 0.0000, 50.1689)]
]
var plane_004 = [
	[Vector3(-16.5296, 9.5948, -13.8311), Vector3(15.4704, 9.5948, -13.8311), Vector3(15.4704, 0.0225, -13.8311)],  [Vector3(-16.5296, 9.5948, -13.8311), Vector3(15.4704, 0.0225, -13.8311), Vector3(-16.5296, 0.0225, -13.8311)]
]
var plane_005 = [
	[Vector3(-16.5296, 9.5948, 50.1689), Vector3(15.4704, 9.5948, 50.1689), Vector3(15.4704, 0.0225, 50.1689)],  [Vector3(-16.5296, 9.5948, 50.1689), Vector3(15.4704, 0.0225, 50.1689), Vector3(-16.5296, 0.0225, 50.1689)]
]

var cube_005 = [
	[Vector3(42.4966, -0.9000, -2.4637), Vector3(42.4966, 0.9000, -2.4637), Vector3(42.4966, 0.9000, 3.5363)],  [Vector3(42.4966, -0.9000, -2.4637), Vector3(42.4966, 0.9000, 3.5363), Vector3(42.4966, -0.9000, 3.5363)],  [Vector3(42.4966, -0.9000, 3.5363), Vector3(42.4966, 0.9000, 3.5363), Vector3(48.4966, 0.9000, 3.5363)],  [Vector3(42.4966, -0.9000, 3.5363), Vector3(48.4966, 0.9000, 3.5363), Vector3(48.4966, -0.9000, 3.5363)],  [Vector3(48.4966, -0.9000, 3.5363), Vector3(48.4966, 0.9000, 3.5363), Vector3(48.4966, 0.9000, -2.4637)],  [Vector3(48.4966, -0.9000, 3.5363), Vector3(48.4966, 0.9000, -2.4637), Vector3(48.4966, -0.9000, -2.4637)],  [Vector3(48.4966, -0.9000, -2.4637), Vector3(48.4966, 0.9000, -2.4637), Vector3(42.4966, 0.9000, -2.4637)],  [Vector3(48.4966, -0.9000, -2.4637), Vector3(42.4966, 0.9000, -2.4637), Vector3(42.4966, -0.9000, -2.4637)],  [Vector3(42.4966, -0.9000, 3.5363), Vector3(48.4966, -0.9000, 3.5363), Vector3(48.4966, -0.9000, -2.4637)],  [Vector3(42.4966, -0.9000, 3.5363), Vector3(48.4966, -0.9000, -2.4637), Vector3(42.4966, -0.9000, -2.4637)],  [Vector3(48.4966, 0.9000, 3.5363), Vector3(42.4966, 0.9000, 3.5363), Vector3(42.4966, 0.9000, -2.4637)],  [Vector3(48.4966, 0.9000, 3.5363), Vector3(42.4966, 0.9000, -2.4637), Vector3(48.4966, 0.9000, -2.4637)]
]
var cube_006 = [
	[Vector3(50.4966, 4.1000, 4.5363), Vector3(50.4966, 5.9000, 4.5363), Vector3(50.4966, 5.9000, 10.5363)],  [Vector3(50.4966, 4.1000, 4.5363), Vector3(50.4966, 5.9000, 10.5363), Vector3(50.4966, 4.1000, 10.5363)],  [Vector3(50.4966, 4.1000, 10.5363), Vector3(50.4966, 5.9000, 10.5363), Vector3(56.4966, 5.9000, 10.5363)],  [Vector3(50.4966, 4.1000, 10.5363), Vector3(56.4966, 5.9000, 10.5363), Vector3(56.4966, 4.1000, 10.5363)],  [Vector3(56.4966, 4.1000, 10.5363), Vector3(56.4966, 5.9000, 10.5363), Vector3(56.4966, 5.9000, 4.5363)],  [Vector3(56.4966, 4.1000, 10.5363), Vector3(56.4966, 5.9000, 4.5363), Vector3(56.4966, 4.1000, 4.5363)],  [Vector3(56.4966, 4.1000, 4.5363), Vector3(56.4966, 5.9000, 4.5363), Vector3(50.4966, 5.9000, 4.5363)],  [Vector3(56.4966, 4.1000, 4.5363), Vector3(50.4966, 5.9000, 4.5363), Vector3(50.4966, 4.1000, 4.5363)],  [Vector3(50.4966, 4.1000, 10.5363), Vector3(56.4966, 4.1000, 10.5363), Vector3(56.4966, 4.1000, 4.5363)],  [Vector3(50.4966, 4.1000, 10.5363), Vector3(56.4966, 4.1000, 4.5363), Vector3(50.4966, 4.1000, 4.5363)],  [Vector3(56.4966, 5.9000, 10.5363), Vector3(50.4966, 5.9000, 10.5363), Vector3(50.4966, 5.9000, 4.5363)],  [Vector3(56.4966, 5.9000, 10.5363), Vector3(50.4966, 5.9000, 4.5363), Vector3(56.4966, 5.9000, 4.5363)]
]
var cube_007 = [
	[Vector3(43.4966, 7.1000, 12.5363), Vector3(43.4966, 8.9000, 12.5363), Vector3(43.4966, 8.9000, 18.5363)],  [Vector3(43.4966, 7.1000, 12.5363), Vector3(43.4966, 8.9000, 18.5363), Vector3(43.4966, 7.1000, 18.5363)],  [Vector3(43.4966, 7.1000, 18.5363), Vector3(43.4966, 8.9000, 18.5363), Vector3(49.4966, 8.9000, 18.5363)],  [Vector3(43.4966, 7.1000, 18.5363), Vector3(49.4966, 8.9000, 18.5363), Vector3(49.4966, 7.1000, 18.5363)],  [Vector3(49.4966, 7.1000, 18.5363), Vector3(49.4966, 8.9000, 18.5363), Vector3(49.4966, 8.9000, 12.5363)],  [Vector3(49.4966, 7.1000, 18.5363), Vector3(49.4966, 8.9000, 12.5363), Vector3(49.4966, 7.1000, 12.5363)],  [Vector3(49.4966, 7.1000, 12.5363), Vector3(49.4966, 8.9000, 12.5363), Vector3(43.4966, 8.9000, 12.5363)],  [Vector3(49.4966, 7.1000, 12.5363), Vector3(43.4966, 8.9000, 12.5363), Vector3(43.4966, 7.1000, 12.5363)],  [Vector3(43.4966, 7.1000, 18.5363), Vector3(49.4966, 7.1000, 18.5363), Vector3(49.4966, 7.1000, 12.5363)],  [Vector3(43.4966, 7.1000, 18.5363), Vector3(49.4966, 7.1000, 12.5363), Vector3(43.4966, 7.1000, 12.5363)],  [Vector3(49.4966, 8.9000, 18.5363), Vector3(43.4966, 8.9000, 18.5363), Vector3(43.4966, 8.9000, 12.5363)],  [Vector3(49.4966, 8.9000, 18.5363), Vector3(43.4966, 8.9000, 12.5363), Vector3(49.4966, 8.9000, 12.5363)]
]
var cube_008 = [
	[Vector3(51.4966, -3.9000, 28.5363), Vector3(51.4966, -2.1000, 28.5363), Vector3(51.4966, -2.1000, 34.5363)],  [Vector3(51.4966, -3.9000, 28.5363), Vector3(51.4966, -2.1000, 34.5363), Vector3(51.4966, -3.9000, 34.5363)],  [Vector3(51.4966, -3.9000, 34.5363), Vector3(51.4966, -2.1000, 34.5363), Vector3(57.4966, -2.1000, 34.5363)],  [Vector3(51.4966, -3.9000, 34.5363), Vector3(57.4966, -2.1000, 34.5363), Vector3(57.4966, -3.9000, 34.5363)],  [Vector3(57.4966, -3.9000, 34.5363), Vector3(57.4966, -2.1000, 34.5363), Vector3(57.4966, -2.1000, 28.5363)],  [Vector3(57.4966, -3.9000, 34.5363), Vector3(57.4966, -2.1000, 28.5363), Vector3(57.4966, -3.9000, 28.5363)],  [Vector3(57.4966, -3.9000, 28.5363), Vector3(57.4966, -2.1000, 28.5363), Vector3(51.4966, -2.1000, 28.5363)],  [Vector3(57.4966, -3.9000, 28.5363), Vector3(51.4966, -2.1000, 28.5363), Vector3(51.4966, -3.9000, 28.5363)],  [Vector3(51.4966, -3.9000, 34.5363), Vector3(57.4966, -3.9000, 34.5363), Vector3(57.4966, -3.9000, 28.5363)],  [Vector3(51.4966, -3.9000, 34.5363), Vector3(57.4966, -3.9000, 28.5363), Vector3(51.4966, -3.9000, 28.5363)],  [Vector3(57.4966, -2.1000, 34.5363), Vector3(51.4966, -2.1000, 34.5363), Vector3(51.4966, -2.1000, 28.5363)],  [Vector3(57.4966, -2.1000, 34.5363), Vector3(51.4966, -2.1000, 28.5363), Vector3(57.4966, -2.1000, 28.5363)]
]
var cube_009 = [
	[Vector3(59.4966, -0.9000, 37.5363), Vector3(59.4966, 0.9000, 37.5363), Vector3(59.4966, 0.9000, 43.5363)],  [Vector3(59.4966, -0.9000, 37.5363), Vector3(59.4966, 0.9000, 43.5363), Vector3(59.4966, -0.9000, 43.5363)],  [Vector3(59.4966, -0.9000, 43.5363), Vector3(59.4966, 0.9000, 43.5363), Vector3(65.4966, 0.9000, 43.5363)],  [Vector3(59.4966, -0.9000, 43.5363), Vector3(65.4966, 0.9000, 43.5363), Vector3(65.4966, -0.9000, 43.5363)],  [Vector3(65.4966, -0.9000, 43.5363), Vector3(65.4966, 0.9000, 43.5363), Vector3(65.4966, 0.9000, 37.5363)],  [Vector3(65.4966, -0.9000, 43.5363), Vector3(65.4966, 0.9000, 37.5363), Vector3(65.4966, -0.9000, 37.5363)],  [Vector3(65.4966, -0.9000, 37.5363), Vector3(65.4966, 0.9000, 37.5363), Vector3(59.4966, 0.9000, 37.5363)],  [Vector3(65.4966, -0.9000, 37.5363), Vector3(59.4966, 0.9000, 37.5363), Vector3(59.4966, -0.9000, 37.5363)],  [Vector3(59.4966, -0.9000, 43.5363), Vector3(65.4966, -0.9000, 43.5363), Vector3(65.4966, -0.9000, 37.5363)],  [Vector3(59.4966, -0.9000, 43.5363), Vector3(65.4966, -0.9000, 37.5363), Vector3(59.4966, -0.9000, 37.5363)],  [Vector3(65.4966, 0.9000, 43.5363), Vector3(59.4966, 0.9000, 43.5363), Vector3(59.4966, 0.9000, 37.5363)],  [Vector3(65.4966, 0.9000, 43.5363), Vector3(59.4966, 0.9000, 37.5363), Vector3(65.4966, 0.9000, 37.5363)]
]
var cube_010 = [
	[Vector3(57.4966, 1.1000, 48.5363), Vector3(57.4966, 2.9000, 48.5363), Vector3(57.4966, 2.9000, 54.5363)],  [Vector3(57.4966, 1.1000, 48.5363), Vector3(57.4966, 2.9000, 54.5363), Vector3(57.4966, 1.1000, 54.5363)],  [Vector3(57.4966, 1.1000, 54.5363), Vector3(57.4966, 2.9000, 54.5363), Vector3(63.4966, 2.9000, 54.5363)],  [Vector3(57.4966, 1.1000, 54.5363), Vector3(63.4966, 2.9000, 54.5363), Vector3(63.4966, 1.1000, 54.5363)],  [Vector3(63.4966, 1.1000, 54.5363), Vector3(63.4966, 2.9000, 54.5363), Vector3(63.4966, 2.9000, 48.5363)],  [Vector3(63.4966, 1.1000, 54.5363), Vector3(63.4966, 2.9000, 48.5363), Vector3(63.4966, 1.1000, 48.5363)],  [Vector3(63.4966, 1.1000, 48.5363), Vector3(63.4966, 2.9000, 48.5363), Vector3(57.4966, 2.9000, 48.5363)],  [Vector3(63.4966, 1.1000, 48.5363), Vector3(57.4966, 2.9000, 48.5363), Vector3(57.4966, 1.1000, 48.5363)],  [Vector3(57.4966, 1.1000, 54.5363), Vector3(63.4966, 1.1000, 54.5363), Vector3(63.4966, 1.1000, 48.5363)],  [Vector3(57.4966, 1.1000, 54.5363), Vector3(63.4966, 1.1000, 48.5363), Vector3(57.4966, 1.1000, 48.5363)],  [Vector3(63.4966, 2.9000, 54.5363), Vector3(57.4966, 2.9000, 54.5363), Vector3(57.4966, 2.9000, 48.5363)],  [Vector3(63.4966, 2.9000, 54.5363), Vector3(57.4966, 2.9000, 48.5363), Vector3(63.4966, 2.9000, 48.5363)]
]
var cube_011 = [
	[Vector3(57.4966, 3.1000, 58.5363), Vector3(57.4966, 4.9000, 58.5363), Vector3(57.4966, 4.9000, 64.5363)],  [Vector3(57.4966, 3.1000, 58.5363), Vector3(57.4966, 4.9000, 64.5363), Vector3(57.4966, 3.1000, 64.5363)],  [Vector3(57.4966, 3.1000, 64.5363), Vector3(57.4966, 4.9000, 64.5363), Vector3(63.4966, 4.9000, 64.5363)],  [Vector3(57.4966, 3.1000, 64.5363), Vector3(63.4966, 4.9000, 64.5363), Vector3(63.4966, 3.1000, 64.5363)],  [Vector3(63.4966, 3.1000, 64.5363), Vector3(63.4966, 4.9000, 64.5363), Vector3(63.4966, 4.9000, 58.5363)],  [Vector3(63.4966, 3.1000, 64.5363), Vector3(63.4966, 4.9000, 58.5363), Vector3(63.4966, 3.1000, 58.5363)],  [Vector3(63.4966, 3.1000, 58.5363), Vector3(63.4966, 4.9000, 58.5363), Vector3(57.4966, 4.9000, 58.5363)],  [Vector3(63.4966, 3.1000, 58.5363), Vector3(57.4966, 4.9000, 58.5363), Vector3(57.4966, 3.1000, 58.5363)],  [Vector3(57.4966, 3.1000, 64.5363), Vector3(63.4966, 3.1000, 64.5363), Vector3(63.4966, 3.1000, 58.5363)],  [Vector3(57.4966, 3.1000, 64.5363), Vector3(63.4966, 3.1000, 58.5363), Vector3(57.4966, 3.1000, 58.5363)],  [Vector3(63.4966, 4.9000, 64.5363), Vector3(57.4966, 4.9000, 64.5363), Vector3(57.4966, 4.9000, 58.5363)],  [Vector3(63.4966, 4.9000, 64.5363), Vector3(57.4966, 4.9000, 58.5363), Vector3(63.4966, 4.9000, 58.5363)]
]

var plane_006 = [
	[Vector3(100.3144, 9.5948, 38.3112), Vector3(169.6352, 9.5948, 38.3112), Vector3(169.6352, 0.0225, 38.3112)],  [Vector3(100.3144, 9.5948, 38.3112), Vector3(169.6352, 0.0225, 38.3112), Vector3(100.3144, 0.0225, 38.3112)]
]
var plane_007 = [
	[Vector3(100.3144, 9.5948, -32.7644), Vector3(169.6352, 9.5948, -32.7644), Vector3(169.6352, 0.0225, -32.7644)],  [Vector3(100.3144, 9.5948, -32.7644), Vector3(169.6352, 0.0225, -32.7644), Vector3(100.3144, 0.0225, -32.7644)]
]
var plane_008 = [
	[Vector3(169.6352, 0.0000, -32.7644), Vector3(169.6352, 9.6000, -32.7644), Vector3(169.6352, 9.6000, 38.3112)],  [Vector3(169.6352, 0.0000, -32.7644), Vector3(169.6352, 9.6000, 38.3112), Vector3(169.6352, 0.0000, 38.3112)]
]
var plane_009 = [
	[Vector3(100.3144, 0.0000, -32.7644), Vector3(100.3144, 9.6000, -32.7644), Vector3(100.3144, 9.6000, 38.3112)],  [Vector3(100.3144, 0.0000, -32.7644), Vector3(100.3144, 9.6000, 38.3112), Vector3(100.3144, 0.0000, 38.3112)]
]
var plane_010 = [
	[Vector3(100.3144, 0.0000, -32.7644), Vector3(169.6352, 0.0000, -32.7644), Vector3(169.6352, 0.0000, 38.3112)],  [Vector3(100.3144, 0.0000, -32.7644), Vector3(169.6352, 0.0000, 38.3112), Vector3(100.3144, 0.0000, 38.3112)]
]


var arrays_to_render = [[plane_001, plane, ziel_1, ziel_2, ziel_3, ziel_4, ziel_5, plane_002, plane_003, plane_004, plane_005], [cube_005, cube_006, cube_007, cube_008, cube_009, cube_010, cube_011], [plane_006, plane_007, plane_008, plane_009, plane_010,]]

var camera_pos = Vector3(0,0,0)
var camera_rot = Vector2(0,0)
var scene = 1

# Voxel Konfiguration
var voxel_size = 1.0
var max_dda_steps = 150 / voxel_size # Wie viele Voxel angeschaut werden pro Strahl (Ray).

var voxel_grids = {}
var current_rendered_scene = -1

func _draw():
	# Die Szene voxelisieren wenn man Szene wechselt
	if scene != current_rendered_scene:
		if not voxel_grids.has(scene):
			voxel_grids[scene] = _voxelize_scene(scene)
		current_rendered_scene = scene

	var grid = voxel_grids[scene]
	
	# Bildschirm definieren
	var viewport_size = get_viewport_rect().size
	var rows = 50
	var columns = int(rows * 16/9)
	
	var cell_width = viewport_size.x / columns
	var cell_height = viewport_size.y / rows
	
	var screen_rays = _calculate_screen_rays(camera_rot, rows, columns)
	
	# Strahlen feuern für jeden Pixel im Bildschirm
	for row in range(screen_rays.size()):					# Zeilen
		for column in range(screen_rays[row].size()):		# Spalten

			# Den "Voxel Ray Traversal" durchführen
			var hit_distance = _dda_raycast(camera_pos, screen_rays[row][column], grid)

			# Den Pixel zeichnen falls es ein Voxel trifft
			var color = Color(0.0, 0.0, 0.0, 1.0)
			if hit_distance != null:
				var brightness = clamp(1.0 - (hit_distance / 200.0), 0.0, 1.0)
				color = Color(brightness, brightness, brightness)

			var x_pos = column * cell_width
			var y_pos = row * cell_height
			var rect = Rect2(x_pos, y_pos, cell_width, cell_height)
			draw_rect(rect, color)


func _dda_raycast(ray_origin: Vector3, ray_direction: Vector3, grid: Dictionary):
	
	# Der "Voxel Ray Traversal" Algorithmus, nimmt ähnlich zu Raycast einen Ray und berechnet ob etwas im Weg ist.
	# Aber anstatt bei jedem Ray zu schauen ob es ein Polygon trifft, geht der Ray durch Voxel und bei jeden Voxel den
	# er trifft schaut er, ob der Voxel etwas besetzt ist oder nicht.
	# Der genutze Algorithmus und Erklärung: http://www.cse.yorku.ca/~amana/research/grid.pdf
	

	# Camera Position einem Voxel im Gitter zuteilen
	var grid_ray_origin = ray_origin / voxel_size
	
	var current_voxel = Vector3i(
		floor(grid_ray_origin.x), 
		floor(grid_ray_origin.y), 
		floor(grid_ray_origin.z)
	)

	# Den nötigen Abstand berechnen damit zu einem Voxel mit einer anderen x/y/z Koordinate geht.
	var delta_x = abs(1.0 / ray_direction.x)
	var delta_y = abs(1.0 / ray_direction.y)
	var delta_z = abs(1.0 / ray_direction.z)

	# Abstand berechnen zur ersten Voxel Grenze
	var side_x = 0.0
	var step_x = 0
	
	if ray_direction.x > 0:
		step_x = 1
		side_x = (current_voxel.x + 1.0 - grid_ray_origin.x) * delta_x
	elif ray_direction.x < 0:
		step_x = -1
		side_x = (grid_ray_origin.x - current_voxel.x) * delta_x
	
	var side_y = 0.0
	var step_y = 0
	if ray_direction.y > 0:
		step_y = 1
		side_y = (current_voxel.y + 1.0 - grid_ray_origin.y) * delta_y
	elif ray_direction.y < 0:
		step_y = -1
		side_y = (grid_ray_origin.y - current_voxel.y) * delta_y
	
	var side_z = 0.0
	var step_z = 0
	if ray_direction.z > 0:
		step_z = 1
		side_z = (current_voxel.z + 1.0 - grid_ray_origin.z) * delta_z
	elif ray_direction.z < 0:
		step_z = -1
		side_z = (grid_ray_origin.z - current_voxel.z) * delta_z


	# Der "Voxel Ray Traversal"
	for i in range(max_dda_steps):
		
		# Schauen ob der Voxel in dem wir sind etwas drinnen hat.
		if grid.has(current_voxel):
			# Den Abstand von der Kamera zum Zentrum des Voxels berechnen
			var hit_point_world = (Vector3(current_voxel) + Vector3(0.5, 0.5, 0.5)) * voxel_size
			return ray_origin.distance_to(hit_point_world)

		# Wenn der derzeitige Voxel leer ist, die nächste Wand finden und zu ihr bewegen
		if side_x < side_y and side_x < side_z:
			side_x += delta_x
			current_voxel.x += step_x
		elif side_y < side_z:
			side_y += delta_y
			current_voxel.y += step_y
		else:
			side_z += delta_z
			current_voxel.z += step_z

	# Ray hat nichts getroffen
	return null


func _calculate_screen_rays(camera_rot, rows, columns):
	
	# Diese Funktion nimmt die Ecken des Bildschirms und berechnet alle Vektoren die es zwischen den Ecken
	# braucht, damit man die gewünschte Bildschirm Auflösung erreicht
	# (Die Funktion ist gleich wie die vom Raycasting-Algorithmus)
	
	var ray_direction = Basis.from_euler(Vector3(camera_rot.x, camera_rot.y, 0)) #
	
	var top_left = (ray_direction * Vector3(-0.75, 0.445, 0.5)).normalized()
	var top_right = (ray_direction * Vector3(0.75, 0.445, 0.5)).normalized()
	var bottom_left = (ray_direction * Vector3(-0.73, -0.38, 0.5)).normalized()
	var bottom_right = (ray_direction * Vector3(0.73, -0.38, 0.5)).normalized()

	var screen_rays = []
	var left_ray = top_left
	var right_ray = top_right
	
	for row in range(rows):
		var column_rays = []
		var weight_rows = float(row) / rows
		left_ray = top_left.lerp(bottom_left, weight_rows)
		right_ray = top_right.lerp(bottom_right, weight_rows)
		
		for column in range(columns): # Es nimmt die Vektoren links und rechts und berechnet alle Vektoren dazwischen.
			var weight_columns = float(column) / columns
			var mixed_ray = left_ray.lerp(right_ray, weight_columns)
			
			column_rays.append(mixed_ray.normalized())
		
		screen_rays.append(column_rays)
	return(screen_rays)











# Der Voxelizer sowie der Blender-Exporter wurden mithilfe von KI (Gemini) erstellt.
# Der Fokus dieser Arbeit liegt ausschliesslich auf dem Vergleich der Rendering-Algorithmen.
# Die Voxelisation erfolgt bewusst zur Laufzeit in Godot und nicht statisch in Blender,
# um mit unterschiedlichen Voxelgrössen (voxel_size) dynamisch testen zu können.

func _voxelize_scene(scene_index: int) -> Dictionary:
	var scene_data = arrays_to_render[scene_index - 1]
	var voxels: Dictionary = {}
	var half_size: Vector3 = Vector3(voxel_size, voxel_size, voxel_size) * 0.5
	
	for obj in scene_data:
		for face in obj:
			var v0: Vector3 = face[0]
			var v1: Vector3 = face[1]
			var v2: Vector3 = face[2]
			
			# Expand bounding box by 1 grid cell to prevent missing corner intersections
			var min_p = ((v0.min(v1).min(v2) / voxel_size) - Vector3.ONE).floor()
			var max_p = ((v0.max(v1).max(v2) / voxel_size) + Vector3.ONE).ceil()
			
			for x in range(int(min_p.x), int(max_p.x) + 1):
				for y in range(int(min_p.y), int(max_p.y) + 1):
					for z in range(int(min_p.z), int(max_p.z) + 1):
						var grid_pos = Vector3i(x, y, z)
						if voxels.has(grid_pos):
							continue
						
						# Center of the 3D voxel cube
						var voxel_center = (Vector3(grid_pos) + Vector3(0.5, 0.5, 0.5)) * voxel_size
						
						# True 3D Triangle vs Cube Volume Intersection (SAT)
						if _triangle_intersects_aabb(v0, v1, v2, voxel_center, half_size):
							voxels[grid_pos] = true
							
	return voxels


# --- SEPARATING AXIS THEOREM (SAT) TRIANGLE-CUBE TEST ---
# Returns true if a triangle intersects any part of a cubic voxel box
func _triangle_intersects_aabb(v0: Vector3, v1: Vector3, v2: Vector3, box_center: Vector3, half_size: Vector3) -> bool:
	# Translate triangle so the voxel center is at (0, 0, 0)
	var a = v0 - box_center
	var b = v1 - box_center
	var c = v2 - box_center
	
	# Test 1: AABB of the triangle against the voxel AABB
	if max(a.x, max(b.x, c.x)) < -half_size.x or min(a.x, min(b.x, c.x)) > half_size.x: return false
	if max(a.y, max(b.y, c.y)) < -half_size.y or min(a.y, min(b.y, c.y)) > half_size.y: return false
	if max(a.z, max(b.z, c.z)) < -half_size.z or min(a.z, min(b.z, c.z)) > half_size.z: return false
	
	# Triangle edges
	var e0 = b - a
	var e1 = c - b
	var e2 = a - c
	
	# Test 2: Triangle Plane against Voxel Box
	var normal = e0.cross(e1)
	var r = half_size.x * abs(normal.x) + half_size.y * abs(normal.y) + half_size.z * abs(normal.z)
	var s = normal.dot(a)
	if abs(s) > r:
		return false
		
	# Test 3: 9 Cross-Product Axes (Box normals x Triangle edges)
	# Edge 0
	if not _axis_test(e0.z, -e0.y, a.y, a.z, b.y, b.z, c.y, c.z, half_size.y, half_size.z): return false
	if not _axis_test(-e0.z, e0.x, a.x, a.z, b.x, b.z, c.x, c.z, half_size.x, half_size.z): return false
	if not _axis_test(e0.y, -e0.x, a.x, a.y, b.x, b.y, c.x, c.y, half_size.x, half_size.y): return false
	
	# Edge 1
	if not _axis_test(e1.z, -e1.y, a.y, a.z, b.y, b.z, c.y, c.z, half_size.y, half_size.z): return false
	if not _axis_test(-e1.z, e1.x, a.x, a.z, b.x, b.z, c.x, c.z, half_size.x, half_size.z): return false
	if not _axis_test(e1.y, -e1.x, a.x, a.y, b.x, b.y, c.x, c.y, half_size.x, half_size.y): return false
	
	# Edge 2
	if not _axis_test(e2.z, -e2.y, a.y, a.z, b.y, b.z, c.y, c.z, half_size.y, half_size.z): return false
	if not _axis_test(-e2.z, e2.x, a.x, a.z, b.x, b.z, c.x, c.z, half_size.x, half_size.z): return false
	if not _axis_test(e2.y, -e2.x, a.x, a.y, b.x, b.y, c.x, c.y, half_size.x, half_size.y): return false
	
	return true
	
	
func _axis_test(a_axis: float, b_axis: float, v0_a: float, v0_b: float, v1_a: float, v1_b: float, v2_a: float, v2_b: float, h_a: float, h_b: float) -> bool:
	var p0 = a_axis * v0_a + b_axis * v0_b
	var p1 = a_axis * v1_a + b_axis * v1_b
	var p2 = a_axis * v2_a + b_axis * v2_b
	var min_p = min(p0, min(p1, p2))
	var max_p = max(p0, max(p1, p2))
	var rad = h_a * abs(a_axis) + h_b * abs(b_axis)
	return not (min_p > rad or max_p < -rad)
