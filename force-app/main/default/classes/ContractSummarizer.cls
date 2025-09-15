public class ContractSummarizer implements Queueable {
    private Id contractId;
    public ContractSummarizer(Id contractId) { this.contractId = contractId; }

    public void execute(QueueableContext qc) {
        Contract__c c = [SELECT Id, Terms__c FROM Contract__c WHERE Id = :contractId];

        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:https://3dfcf00e2d64.ngrok-free.app/api/generate');
        req.setMethod('POST');
        req.setHeader('Content-Type','application/json');
        req.setBody(JSON.serialize(new Map<String,Object>{
            'model'  => 'gemma3:1b',
            'prompt' => 'Summarize the following contract in simple bullet points:\n\n' + c.Terms__c,
            'stream' => false
        }));

        Http http = new Http();
        HttpResponse res = http.send(req);

        if (res.getStatusCode() == 200) {
            Map<String,Object> m = (Map<String,Object>) JSON.deserializeUntyped(res.getBody());
            String summary = (String) m.get('response');
            c.Contract_Summary__c = summary;
            update c;
        }
    }

    @InvocableMethod
    public static void summarizeContract(List<Id> ids) {
        for (Id id : ids) System.enqueueJob(new ContractSummarizer(id));
    }
}
