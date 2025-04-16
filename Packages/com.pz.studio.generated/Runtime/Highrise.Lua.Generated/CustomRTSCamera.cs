/*

    Copyright (c) 2025 Pocketz World. All rights reserved.

    This is a generated file, do not edit!

    Generated by com.pz.studio
*/

#if UNITY_EDITOR

using System;
using System.Linq;
using UnityEngine;
using Highrise.Client;
using Highrise.Studio;
using Highrise.Lua;

namespace Highrise.Lua.Generated
{
    [AddComponentMenu("Lua/CustomRTSCamera")]
    [LuaRegisterType(0x2e555b14f1d665c2, typeof(LuaBehaviour))]
    public class CustomRTSCamera : LuaBehaviourThunk
    {
        private const string s_scriptGUID = "caf24927d3771c744be4275b7e7bff2f";
        public override string ScriptGUID => s_scriptGUID;

        [Header("Zoom Settings")]
        [SerializeField] public System.Double m_zoom = 15;
        [SerializeField] public System.Double m_zoomMin = 10;
        [SerializeField] public System.Double m_zoomMax = 50;
        [SerializeField] public System.Double m_fov = 30;
        [Header("Defaults")]
        [SerializeField] public System.Boolean m_allowRotation = true;
        [SerializeField] public System.Double m_pitch = 30;
        [SerializeField] public System.Double m_yaw = 45;
        [SerializeField] public System.Boolean m_centerOnCharacterWhenSpawned = true;
        [Tooltip("0 means no centering, as you approach 1 the centering will get faster, 1 means immediate centering")]
        [Range(0,1)]
        [SerializeField] public System.Double m_centerOnCharacterWhenMovingSpeed = 0;
        [SerializeField] public System.Boolean m_orthographic = false;
        [SerializeField] public System.Boolean m_keepPlayerInView = false;
        [SerializeField] public System.Double m_keepPlayerInViewPanDuration = 0.5;

        protected override SerializedPropertyValue[] SerializeProperties()
        {
            if (_script == null)
                return Array.Empty<SerializedPropertyValue>();

            return new SerializedPropertyValue[]
            {
                CreateSerializedProperty(_script.GetPropertyAt(0), m_zoom),
                CreateSerializedProperty(_script.GetPropertyAt(1), m_zoomMin),
                CreateSerializedProperty(_script.GetPropertyAt(2), m_zoomMax),
                CreateSerializedProperty(_script.GetPropertyAt(3), m_fov),
                CreateSerializedProperty(_script.GetPropertyAt(4), m_allowRotation),
                CreateSerializedProperty(_script.GetPropertyAt(5), m_pitch),
                CreateSerializedProperty(_script.GetPropertyAt(6), m_yaw),
                CreateSerializedProperty(_script.GetPropertyAt(7), m_centerOnCharacterWhenSpawned),
                CreateSerializedProperty(_script.GetPropertyAt(8), m_centerOnCharacterWhenMovingSpeed),
                CreateSerializedProperty(_script.GetPropertyAt(9), m_orthographic),
                CreateSerializedProperty(_script.GetPropertyAt(10), m_keepPlayerInView),
                CreateSerializedProperty(_script.GetPropertyAt(11), m_keepPlayerInViewPanDuration),
            };
        }
    }
}

#endif
