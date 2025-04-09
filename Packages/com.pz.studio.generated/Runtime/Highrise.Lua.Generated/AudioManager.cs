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
    [AddComponentMenu("Lua/AudioManager")]
    [LuaRegisterType(0x54ef1694c40a5ef8, typeof(LuaBehaviour))]
    public class AudioManager : LuaBehaviourThunk
    {
        private const string s_scriptGUID = "d76b99db0385e4e4aa0d034e8e6cef97";
        public override string ScriptGUID => s_scriptGUID;

        [SerializeField] public UnityEngine.Transform m_audioRoot = default;
        [SerializeField] public Highrise.AudioShader m_ambience = default;

        protected override SerializedPropertyValue[] SerializeProperties()
        {
            if (_script == null)
                return Array.Empty<SerializedPropertyValue>();

            return new SerializedPropertyValue[]
            {
                CreateSerializedProperty(_script.GetPropertyAt(0), m_audioRoot),
                CreateSerializedProperty(_script.GetPropertyAt(1), m_ambience),
            };
        }
    }
}

#endif
