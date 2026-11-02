@icon("res://dev_textures/camera_effect.png")
@abstract class_name CameraEffect
extends Node


@abstract
func tick(delta: float) -> CameraOffset ## returns vector3 offset
