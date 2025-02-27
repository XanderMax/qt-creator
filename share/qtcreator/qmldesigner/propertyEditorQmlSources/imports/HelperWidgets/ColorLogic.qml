/****************************************************************************
**
** Copyright (C) 2021 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of Qt Creator.
**
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3 as published by the Free Software
** Foundation with exceptions as appearing in the file LICENSE.GPL3-EXCEPT
** included in the packaging of this file. Please review the following
** information to ensure the GNU General Public License requirements will
** be met: https://www.gnu.org/licenses/gpl-3.0.html.
**
****************************************************************************/

import QtQuick 2.15
import StudioTheme 1.0 as StudioTheme

QtObject {
    id: innerObject

    property variant backendValue
    property color textColor: StudioTheme.Values.themeTextColor
    property variant valueFromBackend: backendValue === undefined ? 0 : backendValue.value
    property bool baseStateFlag: isBaseState
    property bool isInModel: {
        if (backendValue !== undefined && backendValue.isInModel !== undefined)
            return backendValue.isInModel

        return false
    }
    property bool isInSubState: {
        if (backendValue !== undefined && backendValue.isInSubState !== undefined)
            return backendValue.isInSubState

        return false
    }
    property bool highlight: textColor === __changedTextColor
    property bool errorState: false

    readonly property color __defaultTextColor: StudioTheme.Values.themeTextColor
    readonly property color __changedTextColor: StudioTheme.Values.themeInteraction
    readonly property color __errorTextColor: StudioTheme.Values.themeError

    onBackendValueChanged: evaluate()
    onValueFromBackendChanged: evaluate()
    onBaseStateFlagChanged: evaluate()
    onIsInModelChanged: evaluate()
    onIsInSubStateChanged: evaluate()
    onErrorStateChanged: evaluate()

    function evaluate() {
        if (innerObject.backendValue === undefined)
            return

        if (innerObject.errorState) {
            innerObject.textColor = __errorTextColor
            return
        }

        if (innerObject.baseStateFlag) {
            if (innerObject.backendValue.isInModel)
                innerObject.textColor = __changedTextColor
            else
                innerObject.textColor = __defaultTextColor
        } else {
            if (innerObject.backendValue.isInSubState)
                innerObject.textColor = StudioTheme.Values.themeChangedStateText
            else
                innerObject.textColor = __defaultTextColor
        }
    }
}
