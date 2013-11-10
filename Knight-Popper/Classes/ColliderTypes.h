/**
 * @filename ColliderTypes.h
 * @author Morgan Wall
 * @date 10-11-2013
 *
 * @brief The unique identifiers used for different collider types in the game.
 */

#ifndef Knight_Popper_ColliderTypes_h
#define Knight_Popper_ColliderTypes_h

typedef enum colliderTypes {
    ColliderTypeNode = 0,
    ColliderTypeTarget = 1 << 0,
    ColliderTypeProjectile = 1 << 1
} ColliderType;

#endif
