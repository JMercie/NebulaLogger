//------------------------------------------------------------------------------------------------//
// This file is part of the Nebula Logger project, released under the MIT License.                //
// See LICENSE file or go to https://github.com/jongpie/NebulaLogger for full license details.    //
//------------------------------------------------------------------------------------------------//

@IsTest
private class LoggerTagHandler_Tests {
    @IsTest
    static void it_should_set_unique_id_when_enabled() {
        LoggerTag__c tag = new LoggerTag__c(Name = 'some tag');
        insert tag;

        tag = [SELECT Id, Name, UniqueId__c FROM LoggerTag__c WHERE Id = :tag.Id];
        System.assertEquals(tag.Name, tag.UniqueId__c);
    }

    @IsTest
    static void it_should_not_set_unique_id_when_disabled() {
        LoggerSObjectHandler__mdt loggerTagHandlerConfiguration = new LoggerSObjectHandler__mdt(
            IsEnabled__c = false,
            SObjectType__c = LoggerTag__c.SObjectType.getDescribe().getName()
        );
        LoggerSObjectHandler.setMockConfiguration(Schema.LoggerTag__c.SObjectType, loggerTagHandlerConfiguration);

        LoggerTag__c tag = new LoggerTag__c(Name = 'some tag');
        insert tag;

        tag = [SELECT Id, Name, UniqueId__c FROM LoggerTag__c WHERE Id = :tag.Id];
        System.assertEquals(null, tag.UniqueId__c);
    }

    @IsTest
    static void it_should_not_insert_duplicate_tag() {
        LoggerTag__c tag = new LoggerTag__c(Name = 'some tag');
        insert tag;

        LoggerTag__c duplicateTag = new LoggerTag__c(Name = tag.Name);
        try {
            insert duplicateTag;
            System.assert(false, 'Exception expected on previous line');
        } catch (Exception ex) {
            String expectedDuplicateError = 'DUPLICATE_VALUE, duplicate value found';
            System.assert(ex.getMessage().contains(expectedDuplicateError), ex.getMessage());
        }
    }
}