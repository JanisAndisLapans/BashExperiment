import org.apache.solr.core.*;
import org.apache.solr.schema.IndexSchema;
import org.apache.solr.request.SolrQueryRequestBase;
import org.apache.solr.response.SolrQueryResponse;
import org.apache.solr.util.TestHarness;
import org.apache.solr.common.SolrInputDocument;
import org.apache.solr.search.SolrIndexSearcher;
import org.apache.solr.common.params.ModifiableSolrParams;

public class SolrExample {
    public static void main(String[] args) throws Exception {
        // Create a test Solr core in-memory
        TestHarness testHarness = new TestHarness("solrconfig.xml", "schema.xml");
        IndexSchema schema = testHarness.getCore().getLatestSchema();

        // Create a test document
        SolrInputDocument doc = new SolrInputDocument();
        doc.addField("id", "1");
        doc.addField("title", "Hello Solr");

        // Add document to Solr
        testHarness.update(doc, true);

        // Commit changes
        testHarness.getCore().getUpdateHandler().commit(new CommitUpdateCommand(null, false));

        // Create search parameters
        ModifiableSolrParams params = new ModifiableSolrParams();
        params.set("q", "title:Hello");

        // Search for the document
        SolrQueryRequestBase req = new SolrQueryRequestBase(testHarness.getCore(), params) {};
        SolrQueryResponse rsp = new SolrQueryResponse();
        SolrIndexSearcher searcher = testHarness.getCore().getSearcher().get();

        // Execute query
        searcher.search(req, rsp);

        // Print results
        System.out.println("Search Results: " + rsp.getValues());

        // Close resources
        testHarness.close();
    }
}
