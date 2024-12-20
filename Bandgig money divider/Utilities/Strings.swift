import Foundation

enum Strings {
    enum General {
        static let cancel = NSLocalizedString("Cancel", comment: "Cancel button text")
        static let save = NSLocalizedString("Save", comment: "Save button text")
        static let ok = NSLocalizedString("OK", comment: "OK button text")
        static let edit = NSLocalizedString("Edit", comment: "Edit button text")
        static let delete = NSLocalizedString("Delete", comment: "Delete button text")
        static let done = NSLocalizedString("Done", comment: "Done button text")
        static let saveLocalized = NSLocalizedString("Lagre", comment: "Localized save button text")
        static let cancelLocalized = NSLocalizedString("Avbryt", comment: "Localized cancel button text")
        static let editLocalized = NSLocalizedString("Rediger", comment: "Localized edit button text")
        static let deleteLocalized = NSLocalizedString("Slett", comment: "Localized delete button text")
    }
    
    enum Common {
        static let save = NSLocalizedString("Lagre", comment: "Save button text")
        static let cancel = NSLocalizedString("Avbryt", comment: "Cancel button text")
        static let delete = NSLocalizedString("Slett", comment: "Delete button text")
        static let edit = NSLocalizedString("Rediger", comment: "Edit button text")
        static let done = NSLocalizedString("Ferdig", comment: "Done button text")
        static let ok = NSLocalizedString("OK", comment: "OK button text")
    }
    
    enum Band {
        static let bands = NSLocalizedString("Bands", comment: "Bands list title")
        static let addBand = NSLocalizedString("Add Band", comment: "Add band button text")
        static let members = NSLocalizedString("Medlemmer", comment: "Band members section header")
        static let noMembers = NSLocalizedString("Ingen medlemmer lagt til", comment: "No members message")
        static let addMember = NSLocalizedString("Legg til medlem", comment: "Add member button text")
        static let name = NSLocalizedString("Name", comment: "Name field label")
        static let mileageCompensation = NSLocalizedString("Mileage Compensation", comment: "Mileage compensation section header")
        static let fillInRequiredFields = NSLocalizedString("Please fill in all required fields", comment: "Validation message")
        static let editMember = NSLocalizedString("Edit Member", comment: "Edit member title")
        static let noBands = NSLocalizedString("No bands yet", comment: "Empty state title")
        static let noBandsMessage = NSLocalizedString("Add your first band to get started", comment: "Empty state message")
        static let noGigs = NSLocalizedString("Ingen spillejobber lagt til", comment: "No gigs message")
        static let gigs = NSLocalizedString("Spillejobber", comment: "Gigs section header")
        static let addGig = NSLocalizedString("Legg til spillejobb", comment: "Add gig button text")
        static let memberCount = NSLocalizedString("%d members", comment: "Member count")
        static let gigCount = NSLocalizedString("%d gigs", comment: "Gig count")
        static let memberDetails = NSLocalizedString("Member Details", comment: "Member details section header")
        static let phoneNumber = NSLocalizedString("Phone Number", comment: "Phone number field label")
        static let email = NSLocalizedString("Email", comment: "Email field label")
        static let paymentInfo = NSLocalizedString("Payment Information", comment: "Payment info section header")
        static let accountNumber = NSLocalizedString("Account Number", comment: "Account number field label")
        static let vipps = NSLocalizedString("Vipps", comment: "Vipps field label")
        static let ratePerKm = NSLocalizedString("Rate per km", comment: "Rate per kilometer label")
        static let bandDetails = NSLocalizedString("Band Details", comment: "Band details section header")
    }
    
    enum Member {
        static let name = NSLocalizedString("Navn", comment: "Name field label")
        static let drivingCompensation = NSLocalizedString("Kjøregodtgjørelse", comment: "Driving compensation field label")
        static let perKilometer = NSLocalizedString("kr/km", comment: "Per kilometer label")
    }
    
    enum Settings {
        static let settings = NSLocalizedString("Settings", comment: "Settings screen title")
        static let defaults = NSLocalizedString("Defaults", comment: "Defaults section header")
        static let defaultMileageRate = NSLocalizedString("Default Mileage Rate", comment: "Default mileage rate field label")
        static let about = NSLocalizedString("About", comment: "About section header")
        static let version = NSLocalizedString("Version", comment: "Version field label")
        static let currency = NSLocalizedString("Currency", comment: "Currency selection label")
    }
    
    enum Gig {
        static let newGig = NSLocalizedString("Ny spillejobb", comment: "New gig title")
        static let member = NSLocalizedString("Medlem", comment: "Member field label")
        static let selectMember = NSLocalizedString("Velg medlem", comment: "Select member placeholder")
        static let venue = NSLocalizedString("Sted", comment: "Venue field label")
        static let location = NSLocalizedString("Sted", comment: "Location field label")
        static let date = NSLocalizedString("Dato", comment: "Date field label")
        static let basicInfo = NSLocalizedString("Grunnleggende informasjon", comment: "Basic information section header")
        static let economy = NSLocalizedString("Økonomi", comment: "Economy section header")
        static let grossIncome = NSLocalizedString("Bruttoinntekt", comment: "Gross income field label")
        static let paRental = NSLocalizedString("PA-leie", comment: "PA rental field label")
        static let driving = NSLocalizedString("Kjøring", comment: "Driving section header")
        static let addDriving = NSLocalizedString("Legg til kjøring", comment: "Add driving button text")
        static let otherExpenses = NSLocalizedString("Andre utgifter", comment: "Other expenses section header")
        static let addExpense = NSLocalizedString("Legg til utgift", comment: "Add expense button text")
        static let editGig = NSLocalizedString("Rediger spillejobb", comment: "Edit gig title")
        static let kilometers = NSLocalizedString("kilometer", comment: "Kilometers field label")
        static let km = NSLocalizedString("km", comment: "Kilometers abbreviation")
        static let description = NSLocalizedString("Beskrivelse", comment: "Description field label")
        static let amount = NSLocalizedString("Beløp", comment: "Amount field label")
        static let receipt = NSLocalizedString("Receipt", comment: "Receipt field label")
        static let receiptOptional = NSLocalizedString("Receipt (optional)", comment: "Optional receipt field label")
        static let receiptSaved = NSLocalizedString("Receipt saved", comment: "Receipt saved confirmation")
        static let chooseSource = NSLocalizedString("Choose source", comment: "Image source selection title")
        static let takePhoto = NSLocalizedString("Take Photo", comment: "Take photo button text")
        static let chooseFromLibrary = NSLocalizedString("Choose from Library", comment: "Choose from library button text")
        static let cameraNotAvailable = NSLocalizedString("Camera not available", comment: "Camera not available alert title")
        static let cameraNotAvailableMessage = NSLocalizedString("Camera is not available on this device. Try running the app on a physical device.", comment: "Camera not available alert message")
        static let economySummary = NSLocalizedString("Economy", comment: "Economy section header")
        static let summary = NSLocalizedString("Oversikt", comment: "Summary section header")
        static let totalIncome = NSLocalizedString("Total Income", comment: "Total income label")
        static let totalExpenses = NSLocalizedString("Total Expenses", comment: "Total expenses label")
        static let netIncome = NSLocalizedString("Nettoinntekt", comment: "Net income label")
        static let perMember = NSLocalizedString("Per person", comment: "Per member label")
        static let drivingDetails = NSLocalizedString("Driving Details", comment: "Driving details section header")
        static let compensation = NSLocalizedString("Compensation", comment: "Compensation section header")
        static let totalCompensation = NSLocalizedString("Total Compensation", comment: "Total compensation label")
        static let totalDriving = NSLocalizedString("Total Driving", comment: "Total driving expenses label")
        static let noDriving = NSLocalizedString("Ingen kjøring lagt til", comment: "No driving message")
        static let noExpenses = NSLocalizedString("Ingen utgifter registrert", comment: "No expenses message")
    }
    
    enum Driving {
        static let member = NSLocalizedString("Medlem", comment: "Member field label")
        static let selectMember = NSLocalizedString("Velg medlem", comment: "Select member placeholder")
        static let distance = NSLocalizedString("Distanse", comment: "Distance field label")
        static let kilometers = NSLocalizedString("Kilometer", comment: "Kilometers field label")
        static let compensation = NSLocalizedString("Godtgjørelse", comment: "Compensation field label")
        static let rate = NSLocalizedString("Sats", comment: "Rate field label")
        static let total = NSLocalizedString("Totalt", comment: "Total field label")
        static let addDriving = NSLocalizedString("Legg til kjøring", comment: "Add driving button text")
    }
    
    enum Expense {
        static let description = NSLocalizedString("Beskrivelse", comment: "Description field label")
        static let amount = NSLocalizedString("Beløp", comment: "Amount field label")
    }
    
    enum Tips {
        static let tips = NSLocalizedString("Tips", comment: "Tips screen title")
        static let gettingStarted = NSLocalizedString("Getting Started", comment: "Getting started section header")
        static let addingGigs = NSLocalizedString("Adding Gigs", comment: "Adding gigs section header")
        static let managingExpenses = NSLocalizedString("Managing Expenses", comment: "Managing expenses section header")
        
        static let addBandTip = NSLocalizedString("Start by creating a band and adding its details.", comment: "Add band tip")
        static let addMembersTip = NSLocalizedString("Add all band members who should be included in the money distribution.", comment: "Add members tip")
        static let setMileageRateTip = NSLocalizedString("Set mileage compensation rates for members who drive to gigs.", comment: "Set mileage rate tip")
        
        static let addGigTip = NSLocalizedString("Add new gigs with location, date, and income details.", comment: "Add gig tip")
        static let addExpensesTip = NSLocalizedString("Record all expenses related to the gig, like PA rental or equipment.", comment: "Add expenses tip")
        static let addDrivingTip = NSLocalizedString("Add driving details for members who drove to the gig.", comment: "Add driving tip")
        
        static let receiptsTip = NSLocalizedString("Take photos of receipts to keep track of expenses.", comment: "Receipts tip")
        static let editExpensesTip = NSLocalizedString("You can edit or delete expenses at any time.", comment: "Edit expenses tip")
    }
}
