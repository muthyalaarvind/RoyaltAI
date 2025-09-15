/**
 * RoyaltyUtil
 * Utility class for royalty calculations and related helper methods.
 */
public class RoyaltyUtil {
    /**
     * Calculates the royalty amount.
     * @param ratePerUnit The rate per unit/view.
     * @param totalViews The total number of views/units.
     * @return The calculated royalty amount.
     */
    public static Decimal calculatedRoyalty(Decimal ratePerUnit, Decimal totalViews) {
        if (ratePerUnit == null || totalViews == null) {
            throw new IllegalArgumentException('Rate per unit and total views cannot be null');
        }
        return ratePerUnit * totalViews;
    }

    /**
     * Creates a royalty record (returns calculated value, does not insert).
     * @param licenseId The License__c record Id.
     * @param ratePerUnit The rate per unit/view.
     * @param totalViews The total number of views/units.
     * @return The calculated royalty amount.
     */
    public static Decimal createRoyaltyRecord(Id licenseId, Decimal ratePerUnit, Integer totalViews) {
        if (licenseId == null || ratePerUnit == null || totalViews == null) {
            throw new IllegalArgumentException('License, rate per unit, and total views cannot be null');
        }
        return ratePerUnit * totalViews;
    }

    /**
     * Calculates and logs royalty for a given Royalty__c record.
     * Note: Total_Royalty__c is a formula field, so it is not updated directly.
     * @param royalty The Royalty__c record.
     */
    public static void processRoyalty(Royalty__c royalty) {
        if (royalty == null) {
            throw new IllegalArgumentException('Royalty record cannot be null');
        }
        Decimal calculatedRoyalty = calculatedRoyalty(royalty.Rate_Per_Unit__c, royalty.Total_Views__c);
        System.debug('Calculated Royalty: ' + calculatedRoyalty);
        // Total_Royalty__c is a formula field, so no direct update.
    }
}