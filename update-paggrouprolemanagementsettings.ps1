Import-Module Microsoft.Graph.Identity.SignIns
<#
.SYNOPSIS
    Update Role Management Notification Settings for privileged access group roles (PAG) in Entra ID PIM.

.DESCRIPTION
    Updates the notification settings for privileged access group (PAG) roles in Entra ID PIM. 
    It retrieves all role management policy assignments for the specified group and updates their notification rules 
    to use the provided recipient email address. This helps ensure that notifications for eligibility and assignment 
    events are sent to the correct recipients according to your organization's requirements.


.PARAMETER GroupId
    The objectID of the privileged access group for which to update role management notification settings.

.PARAMETER NotificationRecipient
    The email address to receive notifications for role management events.

.PARAMETER groupdisplayname
    The display name of the privileged access group for logging purposes.

.EXAMPLE
foreach($group in $groups) {
    Update-paggroupManagementNotificationSettings -GroupId $group.id -NotificationRecipient "admin@example.com" -groupdisplayname $group.displayName
}

.NOTES
Author: Bas Oudehinken
Date : 03-09-2025
Version: 1.0
#>

function update-paggrouprolemanagementsettings {
    param (
        [Parameter(Mandatory=$true)]
        [string]$GroupId,
        [Parameter(Mandatory=$true)]
        [string]$NotificationRecipient,
        [Parameter(Mandatory=$true)]
        [string]$groupdisplayname
    )

    
    $notificationRulesArray = @(
        @{
            "@odata.type" = "#microsoft.graph.unifiedRoleManagementPolicyNotificationRule"
            id = "Notification_Admin_Admin_Eligibility"
            notificationType = "Email"
            isDefaultRecipientsEnabled = $false
            notificationRecipients = @($NotificationRecipient)
            recipienttype = "Admin"
            notificationLevel = "Critical"
            target = @{
                caller = "Admin"
                operations = @("All")
                level = "Eligibility"
                inheritableSettings = @()
                enforcedSettings = @()
            }
        },
        @{
            "@odata.type" = "#microsoft.graph.unifiedRoleManagementPolicyNotificationRule"
            id = "Notification_Requestor_Admin_Eligibility"
            notificationType = "Email"
            isDefaultRecipientsEnabled = $false
            notificationRecipients = @($NotificationRecipient)
            recipienttype = "Requestor"
            notificationLevel = "Critical"
            target = @{
                caller = "Admin"
                operations = @("All")
                level = "Eligibility"
                inheritableSettings = @()
                enforcedSettings = @()
            }
        },
        @{
            "@odata.type" = "#microsoft.graph.unifiedRoleManagementPolicyNotificationRule"
            id = "Notification_Approver_Admin_Eligibility"
            notificationType = "Email"
            isDefaultRecipientsEnabled = $true
            notificationRecipients = @($NotificationRecipient)
            recipienttype = "Approver"
            notificationLevel = "All"
            target = @{
                caller = "Admin"
                operations = @("All")
                level = "Eligibility"
                inheritableSettings = @()
                enforcedSettings = @()
            }
        },
        @{
            "@odata.type" = "#microsoft.graph.unifiedRoleManagementPolicyNotificationRule"
            id = "Notification_Admin_Admin_Assignment"
            notificationType = "Email"
            isDefaultRecipientsEnabled = $false
            notificationRecipients = @($NotificationRecipient)
            recipienttype = "Admin"
            notificationLevel = "Critical"
            target = @{
                caller = "Admin"
                operations = @("All")
                level = "Assignment"
                inheritableSettings = @()
                enforcedSettings = @()
            }
        },
        @{
            "@odata.type" = "#microsoft.graph.unifiedRoleManagementPolicyNotificationRule"
            id = "Notification_Requestor_Admin_Assignment"
            notificationType = "Email"
            isDefaultRecipientsEnabled = $false
            notificationRecipients = @($NotificationRecipient)
            recipienttype = "Requestor"
            notificationLevel = "Critical"
            target = @{
                caller = "Admin"
                operations = @("All")
                level = "Assignment"
                inheritableSettings = @()
                enforcedSettings = @()
            }
        },
        @{
            "@odata.type" = "#microsoft.graph.unifiedRoleManagementPolicyNotificationRule"
            id = "Notification_Approver_Admin_Assignment"
            notificationType = "Email"
            isDefaultRecipientsEnabled = $true
            notificationRecipients = @()
            recipienttype = "Approver"
            notificationLevel = "All"
            target = @{
                caller = "Admin"
                operations = @("All")
                level = "Assignment"
                inheritableSettings = @()
                enforcedSettings = @()
            }
        },
        @{
            "@odata.type" = "#microsoft.graph.unifiedRoleManagementPolicyNotificationRule"
            id = "Notification_Admin_EndUser_Assignment"
            notificationType = "Email"
            isDefaultRecipientsEnabled = $false
            notificationRecipients = @()
            recipienttype = "Admin"
            notificationLevel = "Critical"
            target = @{
                caller = "EndUser"
                operations = @("All")
                level = "Assignment"
                inheritableSettings = @()
                enforcedSettings = @()
            }
        },
        @{
            "@odata.type" = "#microsoft.graph.unifiedRoleManagementPolicyNotificationRule"
            id = "Notification_Requestor_EndUser_Assignment"
            notificationType = "Email"
            isDefaultRecipientsEnabled = $true
            recipientType = "Requestor"
            notificationLevel = "Critical"
            target = @{
                caller = "EndUser"
                operations = @("All")
                level = "Assignment"
                inheritableSettings = @()
                enforcedSettings = @()
            }
        },
        @{
            "@odata.type" = "#microsoft.graph.unifiedRoleManagementPolicyNotificationRule"
            id = "Notification_Approver_EndUser_Assignment"
            notificationType = "Email"
            isDefaultRecipientsEnabled = $true
            recipientType = "Approver"
            notificationLevel = "All"
            target = @{
                caller = "EndUser"
                operations = @("All")
                level = "Assignment"
                inheritableSettings = @()
                enforcedSettings = @()
            }
        }
    )

    $policyassignments = Get-MgPolicyRoleManagementPolicyAssignment -Filter "scopeId eq '$GroupId' and scopeType eq 'Group'"

    foreach ($assignment in $policyassignments) {
        $policyid = $assignment.PolicyId
        Write-Output "Updating $($assignment.RoleDefinitionId) rolesettings for $groupdisplayname ($GroupId)"
        foreach ($rule in $notificationRulesArray) {
            Update-MgPolicyRoleManagementPolicyRule -UnifiedRoleManagementPolicyId $policyid -UnifiedRoleManagementPolicyRuleId $rule.id -BodyParameter $rule
        }
    }
}
