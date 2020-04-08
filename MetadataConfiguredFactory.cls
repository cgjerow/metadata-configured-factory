public with sharing virtual class MetadataConfiguredFactory 
{
    private Map<String,Apex_Factory_Configuration__mdt> classConfigurations 
            = new Map<String,Apex_Factory_Configuration__mdt>();
    @testVisible
    private static String testCase = '';

    public Object getClassInstance(String configurationName)
    {
        if (this.classConfigurations.get(configurationName)==null)
        {
            try {
                classConfigurations.put(configurationName, 
                    [SELECT 
                        DeveloperName, 
                        Apex_Class_Name__c 
                        FROM Apex_Factory_Configuration__mdt 
                        WHERE Configuration_Name__c = :configurationName
                        AND Test_Case__c = :testCase
                    ]
                );
            }
            catch(Exception e)
            {
                throw new MetadataConfiguredFactory.MetadataConfiguredFactoryException(
                    'Error retrieving Apex Factory Configuration with Configuration Name: ' + configurationName 
                    + '. Exactly one non-test configuration should exist.'
                );
            }
        }
        try {
            return Type.forName(this.classConfigurations.get(configurationName).Apex_Class_Name__c).newInstance();
        }
        catch(Exception e)
        {
            throw new MetadataConfiguredFactory.MetadataConfiguredFactoryException(
                'Error instantiating the following Apex Class: ' + this.classConfigurations.get(configurationName).Apex_Class_Name__c
                + '. ' + e.getMessage()
            );
        }
    }

    // public void setTestCase(String testCase)
    // {
    //     testCase = testCase;
    // }

    public class MetadataConfiguredFactoryException extends Exception {}
}