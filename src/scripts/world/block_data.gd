extends Resource


const BLOCK_VERTS := [
    Vector3(-0.5, 0.5, 0.5),
    Vector3(0.5, 0.5, 0.5),
    Vector3(0.5, -0.5, 0.5),
    Vector3(-0.5, -0.5, 0.5),
    Vector3(-0.5, 0.5, -0.5),
    Vector3(0.5, 0.5, -0.5),
    Vector3(0.5, -0.5, -0.5),
    Vector3(-0.5, -0.5, -0.5)
]

const BLOCK_TRIS := [
    [5, 4, 7, 7, 6, 5], # Back Face
    [0, 1, 2, 2, 3, 0], # Front Face
    [4, 5, 1, 1, 0, 4], # Top Face
    [3, 2, 6, 6, 7, 3], # Bottom Face
    [4, 0, 3, 3, 7, 4], # Left Face
    [1, 5, 6, 6, 2, 1], # Right Face
]

const DIRT := Vector2(7, 5)
const TOTAL := Vector2(9, 10)

const initialX := (1.0 / TOTAL.x) * DIRT.x
const finalX := initialX + (1.0 / TOTAL.x)
const initialY := (1.0 / TOTAL.y) * DIRT.y
const finalY := initialY + (1.0 / TOTAL.y)

const BLOCK_UVS := [
    Vector2(initialX, initialY),
    Vector2(finalX, initialY),
    Vector2(finalX, finalY),
    Vector2(finalX, finalY),
    Vector2(initialX, finalY),
    Vector2(initialX, initialY)
]
