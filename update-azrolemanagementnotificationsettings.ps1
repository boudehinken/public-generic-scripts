<#
.SYNOPSIS
Configures notification rules for Azure PIM role management policy assignments.

.DESCRIPTION
Sets up email notification rules for Admin, Requestor, and Approver roles for both eligibility and assignment events on a specified Azure subscription and role. Uses Update-AzRoleManagementPolicy to apply the rules.

.PARAMETER scope
The Azure scope where the PIM role management policy is applied.
#examples are 
# /subscriptions/{subscriptionId}
# /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}
# /providers/Microsoft.Management/managementGroups/{managementGroupId}


.PARAMETER RoleId
The Azure Role Definition ID for which the notification rules will be configured.

.EXAMPLE
Set-PIMNotificationRules -Scope "/subscriptions/{subscriptionId}" -RoleId "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
Set-PIMNotificationRules -Scope "/providers/Microsoft.Management/managementGroups/{managementGroupId}" -RoleId "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
Set-PIMNotificationRules -Scope "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}" -RoleId "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"

.NOTES
Requires the Az.Resources PowerShell module and appropriate permissions to update role management policies.


#To do
WARNING: Upcoming breaking changes in the cmdlet 'Update-AzRoleManagementPolicy' :
- The output type 'Microsoft.Azure.PowerShell.Cmdlets.Resources.Authorization.Models.Api20201001Preview.IRoleManagementPolicy' is changing
- The following properties in the output type are being deprecated : 'EffectiveRule[]' 'Rule[]'
- The following properties are being added to the output type : 'List[EffectiveRule]' 'List[Rule]'
- This change will take effect on '3-11-2025'- The change is expected to take effect from Az version : '15.0.0'
- The change is expected to take effect from version : '9.0.0'
- The parameter : 'Rule' is changing.
The type of the parameter is changing from 'Array' to 'List'.
- This change will take effect on '3-11-2025'- The change is expected to take effect from Az version : '15.0.0'
- The change is expected to take effect from version : '9.0.0'
Note : Go to https://aka.ms/azps-changewarnings for steps to suppress this breaking change warning, and other information on breaking changes in Azure PowerShell.


Author: Bas Oudehinken
Date : 03-09-2025
Version : 1.0

#>


function update-rolemanagementnotificationsettings {
    param(
        [Parameter(Mandatory = $true,
        HelpMessage = "Specify the scope where the PIM role management policy is applied. Examples: /subscriptions/{subscriptionId}, /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}, /providers/Microsoft.Management/managementGroups/{managementGroupId}")]
        [string]$Scope,
        

        [Parameter(Mandatory = $true)]
        [string]$RoleId,
        [Parameter(Mandatory = $true)]
        [string]$NotificationRecipient
    )


    # Get unique policy id for $RoleId on target subscription
    $GetPolicy = Get-AzRoleManagementPolicyAssignment -Scope $Scope | Where-Object { $_.Name -like "*$RoleId*" }
    $PolicyId = ($GetPolicy.PolicyId -split "/")[-1]

    $notification_Admin_Admin_Eligibility = [Microsoft.Azure.PowerShell.Cmdlets.Resources.Authorization.Models.Api20201001Preview.RoleManagementPolicyNotificationRule]@{
        notificationType = "Email";
        recipientType = "Admin";
        isDefaultRecipientsEnabled = "false";
        notificationLevel = "Critical";
        notificationRecipient = $NotificationRecipient;
        id = "Notification_Admin_Admin_Eligibility";
        ruleType = [Microsoft.Azure.PowerShell.Cmdlets.Resources.Authorization.Support.RoleManagementPolicyRuleType]("RoleManagementPolicyNotificationRule");
        targetCaller = "Admin";
        targetOperation = @('All');
        targetLevel = "Eligibility";
        targetObject = $null;
        targetInheritableSetting = $null;
        targetEnforcedSetting = $null;
    }

    $notification_Requestor_Admin_Eligibility = [Microsoft.Azure.PowerShell.Cmdlets.Resources.Authorization.Models.Api20201001Preview.RoleManagementPolicyNotificationRule]@{
        notificationType = "Email";
        recipientType = "Requestor";
        isDefaultRecipientsEnabled = "false";
        notificationLevel = "Critical";
        notificationRecipient = $NotificationRecipient;
        id = "Notification_Requestor_Admin_Eligibility";
        ruleType = [Microsoft.Azure.PowerShell.Cmdlets.Resources.Authorization.Support.RoleManagementPolicyRuleType]("RoleManagementPolicyNotificationRule");
        targetCaller = "Admin";
        targetOperation = @('All');
        targetLevel = "Eligibility";
        targetObject = $null;
        targetInheritableSetting = $null;
        targetEnforcedSetting = $null;
    }

    $notification_Approver_Admin_Eligibility = [Microsoft.Azure.PowerShell.Cmdlets.Resources.Authorization.Models.Api20201001Preview.RoleManagementPolicyNotificationRule]@{
        notificationType = "Email";
        recipientType = "Approver";
        isDefaultRecipientsEnabled = "true";
        notificationLevel = "All";
        notificationRecipient = $NotificationRecipient;
        id = "Notification_Approver_Admin_Eligibility";
        ruleType = [Microsoft.Azure.PowerShell.Cmdlets.Resources.Authorization.Support.RoleManagementPolicyRuleType]("RoleManagementPolicyNotificationRule");
        targetCaller = "Admin";
        targetOperation = @('All');
        targetLevel = "Eligibility";
        targetObject = $null;
        targetInheritableSetting = $null;
        targetEnforcedSetting = $null;
    }

    $notification_Admin_Admin_Assignment = [Microsoft.Azure.PowerShell.Cmdlets.Resources.Authorization.Models.Api20201001Preview.RoleManagementPolicyNotificationRule]@{
        notificationType = "Email";
        recipientType = "Admin";
        isDefaultRecipientsEnabled = "false";
        notificationLevel = "Critical";
        notificationRecipient = $NotificationRecipient;
        id = "Notification_Admin_Admin_Assignment";
        ruleType = [Microsoft.Azure.PowerShell.Cmdlets.Resources.Authorization.Support.RoleManagementPolicyRuleType]("RoleManagementPolicyNotificationRule");
        targetCaller = "Admin";
        targetOperation = @('All');
        targetLevel = "Assignment";
        targetObject = $null;
        targetInheritableSetting = $null;
        targetEnforcedSetting = $null;
    }

    $notification_Requestor_Admin_Assignment = [Microsoft.Azure.PowerShell.Cmdlets.Resources.Authorization.Models.Api20201001Preview.RoleManagementPolicyNotificationRule]@{
        notificationType = "Email";
        recipientType = "Requestor";
        isDefaultRecipientsEnabled = "false";
        notificationLevel = "Critical";
        notificationRecipient = $NotificationRecipient;
        id = "Notification_Requestor_Admin_Assignment";
        ruleType = [Microsoft.Azure.PowerShell.Cmdlets.Resources.Authorization.Support.RoleManagementPolicyRuleType]("RoleManagementPolicyNotificationRule");
        targetCaller = "Admin";
        targetOperation = @('All');
        targetLevel = "Assignment";
        targetObject = $null;
        targetInheritableSetting = $null;
        targetEnforcedSetting = $null;
    }

    $notification_Approver_Admin_Assignment = [Microsoft.Azure.PowerShell.Cmdlets.Resources.Authorization.Models.Api20201001Preview.RoleManagementPolicyNotificationRule]@{
        notificationType = "Email";
        recipientType = "Approver";
        isDefaultRecipientsEnabled = "true";
        notificationLevel = "All";
        notificationRecipient = $null;
        id = "Notification_Approver_Admin_Assignment";
        ruleType = [Microsoft.Azure.PowerShell.Cmdlets.Resources.Authorization.Support.RoleManagementPolicyRuleType]("RoleManagementPolicyNotificationRule");
        targetCaller = "Admin";
        targetOperation = @('All');
        targetLevel = "Assignment";
        targetObject = $null;
        targetInheritableSetting = $null;
        targetEnforcedSetting = $null;
    }

    $notification_Admin_EndUser_Assignment = [Microsoft.Azure.PowerShell.Cmdlets.Resources.Authorization.Models.Api20201001Preview.RoleManagementPolicyNotificationRule]@{
        notificationType = "Email";
        recipientType = "Admin";
        isDefaultRecipientsEnabled = "false";
        notificationLevel = "Critical";
        notificationRecipient = $null;
        id = "Notification_Admin_EndUser_Assignment";
        ruleType = [Microsoft.Azure.PowerShell.Cmdlets.Resources.Authorization.Support.RoleManagementPolicyRuleType]("RoleManagementPolicyNotificationRule");
        targetCaller = "EndUser";
        targetOperation = @('All');
        targetLevel = "Assignment";
        targetObject = $null;
        targetInheritableSetting = $null;
        targetEnforcedSetting = $null;
    }

    $notification_Requestor_EndUser_Assignment = [Microsoft.Azure.PowerShell.Cmdlets.Resources.Authorization.Models.Api20201001Preview.RoleManagementPolicyNotificationRule]@{
        notificationType = "Email";
        recipientType = "Requestor";
        isDefaultRecipientsEnabled = "true";
        notificationLevel = "Critical";
        notificationRecipient = $null;
        id = "Notification_Requestor_EndUser_Assignment";
        ruleType = [Microsoft.Azure.PowerShell.Cmdlets.Resources.Authorization.Support.RoleManagementPolicyRuleType]("RoleManagementPolicyNotificationRule");
        targetCaller = "EndUser";
        targetOperation = @('All');
        targetLevel = "Assignment";
        targetObject = $null;
        targetInheritableSetting = $null;
        targetEnforcedSetting = $null;
    }

    $notification_Approver_EndUser_Assignment = [Microsoft.Azure.PowerShell.Cmdlets.Resources.Authorization.Models.Api20201001Preview.RoleManagementPolicyNotificationRule]@{
        notificationType = "Email";
        recipientType = "Approver";
        isDefaultRecipientsEnabled = "true";
        notificationLevel = "All";
        notificationRecipient = $null;
        id = "Notification_Approver_EndUser_Assignment";
        ruleType = [Microsoft.Azure.PowerShell.Cmdlets.Resources.Authorization.Support.RoleManagementPolicyRuleType]("RoleManagementPolicyNotificationRule");
        targetCaller = "EndUser";
        targetOperation = @('All');
        targetLevel = "Assignment";
        targetObject = $null;
        targetInheritableSetting = $null;
        targetEnforcedSetting = $null;
    }

    # Update settings for $RoleId on target subscription
    $AllRules = [Microsoft.Azure.PowerShell.Cmdlets.Resources.Authorization.Models.Api20201001Preview.IRoleManagementPolicyRule[]]@(
        $notification_Admin_Admin_Eligibility,
        $notification_Requestor_Admin_Eligibility,
        $notification_Approver_Admin_Eligibility,
        $notification_Admin_Admin_Assignment,
        $notification_Requestor_Admin_Assignment,
        $notification_Approver_Admin_Assignment,
        $notification_Admin_EndUser_Assignment,
        $notification_Requestor_EndUser_Assignment,
        $notification_Approver_EndUser_Assignment
    )
    Update-AzRoleManagementPolicy -Scope $Scope -Name $PolicyId -Rule $AllRules
}
