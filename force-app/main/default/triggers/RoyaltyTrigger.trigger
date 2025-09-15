trigger RoyaltyTrigger on Royalty__c (before insert, before update, after insert, after update, after delete) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            RoyaltyTriggerHandler.handleBeforeInsert(Trigger.new);
        } else if (Trigger.isUpdate) {
            RoyaltyTriggerHandler.handleBeforeUpdate(Trigger.new, Trigger.oldMap);
        }
    } else if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            RoyaltyTriggerHandler.handleAfterInsert(Trigger.new);
        } else if (Trigger.isUpdate) {
            RoyaltyTriggerHandler.handleAfterUpdate(Trigger.new, Trigger.oldMap);
        } else if (Trigger.isDelete) {
            RoyaltyTriggerHandler.handleAfterDelete(Trigger.old);
        }
    }
}