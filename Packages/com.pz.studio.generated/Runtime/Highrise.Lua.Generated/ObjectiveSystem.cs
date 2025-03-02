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
    [AddComponentMenu("Lua/ObjectiveSystem")]
    [LuaRegisterType(0x602cee2e21e19b9, typeof(LuaBehaviour))]
    public class ObjectiveSystem : LuaBehaviourThunk
    {
        private const string s_scriptGUID = "3b67554807c39124b9790d664271d35c";
        public override string ScriptGUID => s_scriptGUID;

        [LuaScriptPropertyAttribute("801816f0407bebd419c3380c7ee9ced7")]
        [SerializeField] public UnityEngine.Object m_view = default;

        protected override SerializedPropertyValue[] SerializeProperties()
        {
            if (_script == null)
                return Array.Empty<SerializedPropertyValue>();

            return new SerializedPropertyValue[]
            {
                CreateSerializedProperty(_script.GetPropertyAt(0), m_view),
            };
        }
    }
}

#endif
