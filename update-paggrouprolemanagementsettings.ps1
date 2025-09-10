Import-Module Microsoft.Graph.Identity.SignIns


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
        Write-Output "Updating $($assignment.RoleDefinitionId) rolesettings for Group ID: $GroupId"
        foreach ($rule in $notificationRulesArray) {
            Update-MgPolicyRoleManagementPolicyRule -UnifiedRoleManagementPolicyId $policyid -UnifiedRoleManagementPolicyRuleId $rule.id -BodyParameter $rule
        }
    }
}

# Example usage:
# Update-GroupRoleManagementNotificationSettings -GroupId "objectidofgroup" -NotificationRecipient "mail@domain.com"
