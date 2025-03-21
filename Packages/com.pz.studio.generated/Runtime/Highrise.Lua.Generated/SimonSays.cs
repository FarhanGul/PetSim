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
    [AddComponentMenu("Lua/SimonSays")]
    [LuaRegisterType(0xd8cad5019032851, typeof(LuaBehaviour))]
    public class SimonSays : LuaBehaviourThunk
    {
        private const string s_scriptGUID = "df077903154c52d459a4dd7f619152e4";
        public override string ScriptGUID => s_scriptGUID;

        [SerializeField] public System.String m_rarity = "Common";
        [SerializeField] public System.Double m_stepsRequired = 6;
        [SerializeField] public System.Collections.Generic.List<UnityEngine.GameObject> m_pulseObjects = default;

        protected override SerializedPropertyValue[] SerializeProperties()
        {
            if (_script == null)
                return Array.Empty<SerializedPropertyValue>();

            return new SerializedPropertyValue[]
            {
                CreateSerializedProperty(_script.GetPropertyAt(0), m_rarity),
                CreateSerializedProperty(_script.GetPropertyAt(1), m_stepsRequired),
                CreateSerializedProperty(_script.GetPropertyAt(2), m_pulseObjects),
            };
        }
    }
}

#endif
