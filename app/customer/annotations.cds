using TravelService as service from '../../srv/travel-service';
annotate service.Passenger with @(
    UI.FieldGroup #GeneratedGroup : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : CustomerID,
            },
            {
                $Type : 'UI.DataField',
                Value : CountryCode_code,
            },
            {
                $Type : 'UI.DataField',
                Value : PostalCode,
            },
            {
                $Type : 'UI.DataField',
                Value : City,
            },
            {
                $Type : 'UI.DataField',
                Value : Street,
            },
        ],
    },
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'GeneratedFacet1',
            Label : 'General Information',
            Target : '@UI.FieldGroup#GeneratedGroup',
        },
    ],
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Value : CustomerID,
        },
        {
            $Type : 'UI.DataField',
            Value : createdAt,
        },
        {
            $Type : 'UI.DataField',
            Value : createdBy,
        },
        {
            $Type : 'UI.DataField',
            Value : LastChangedAt,
        },
        {
            $Type : 'UI.DataField',
            Value : LastChangedBy,
        },
        {
            $Type : 'UI.DataField',
            Value : City,
        },
        {
            $Type : 'UI.DataField',
            Value : CountryCode_code,
        },
        {
            $Type : 'UI.DataField',
            Value : PostalCode,
        },
        {
            $Type : 'UI.DataField',
            Value : Street,
        },
        {
            $Type : 'UI.DataField',
            Value : EMailAddress,
        },
    ],
    UI.SelectionFields : [
        CountryCode_code,
        City,
        PostalCode,
    ],
    UI.HeaderFacets : [
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Contact Details',
            ID : 'ContactDetails',
            Target : '@UI.FieldGroup#ContactDetails',
        },
    ],
    UI.FieldGroup #ContactDetails : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : EMailAddress,
            },
            {
                $Type : 'UI.DataField',
                Value : FullName,
            },
            {
                $Type : 'UI.DataField',
                Value : PhoneNumber,
            },
        ],
    },
    UI.HeaderInfo : {
        TypeName : '{i18n>CustomerID}',
        TypeNamePlural : '{i18n>Customers}',
        Title : {
            $Type : 'UI.DataField',
            Value : FullName,
        },
    },
);

