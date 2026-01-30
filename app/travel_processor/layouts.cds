using TravelService from '../../srv/travel-service';
using from '../../db/schema';
using from '../../db/master-data';
using from './value-helps';


//
// annotatios that control the fiori layout
//

annotate TravelService.Travel with @(
    UI                                     : {

        Identification        : [
            {
                $Type : 'UI.DataFieldForAction',
                Action: 'TravelService.acceptTravel',
                Label : '{i18n>AcceptTravel}'
            },
            {
                $Type : 'UI.DataFieldForAction',
                Action: 'TravelService.rejectTravel',
                Label : '{i18n>RejectTravel}'
            },
            {
                $Type : 'UI.DataFieldForAction',
                Action: 'TravelService.deductDiscount',
                Label : '{i18n>Deductdiscount}',
            },
        ],
        HeaderInfo            : {
            TypeName      : '{i18n>Travel}',
            TypeNamePlural: '{i18n>Travels}',
            Title         : {
                $Type: 'UI.DataField',
                Value: Description
            },
            Description   : {
                $Type: 'UI.DataField',
                Value: TravelID
            }
        },
        PresentationVariant   : {
            Text          : 'Default',
            Visualizations: ['@UI.LineItem'],
            SortOrder     : [{
                $Type     : 'Common.SortOrderType',
                Property  : TravelID,
                Descending: true
            }]
        },
        SelectionFields       : [
            to_Agency_AgencyID,
            to_Customer_CustomerID,
            TravelStatus_code,
            BeginDate,
            EndDate,
        ],
        LineItem              : [
            {
                $Type : 'UI.DataFieldForAction',
                Action: 'TravelService.acceptTravel',
                Label : '{i18n>AcceptTravel}'
            },
            {
                $Type : 'UI.DataFieldForAction',
                Action: 'TravelService.rejectTravel',
                Label : '{i18n>RejectTravel}'
            },
            {
                Value            : TravelID,
                ![@UI.Importance]: #High
            },
            {
                Value            : to_Customer_CustomerID,
                ![@UI.Importance]: #High
            },
            {Value: BeginDate},
            {Value: EndDate},
            {Value: BookingFee},
            {Value: TotalPrice},
            {
                $Type            : 'UI.DataField',
                Value            : TravelStatus_code,
                Criticality      : TravelStatus.criticality,
                ![@UI.Importance]: #High
            },
            {
                $Type : 'UI.DataFieldForAction',
                Action: 'TravelService.deductDiscount',
                Label : '{i18n>Deductdiscount}',
            },
            {
                $Type : 'UI.DataFieldForAnnotation',
                Target: '@UI.DataPoint#Progress',
                Label : '{i18n>Progress}',
            },
            {
                $Type : 'UI.DataFieldForAnnotation',
                Target: 'to_Agency/@Communication.Contact#contact',
                Label : '{i18n>ContactName}',
            },
            {
                $Type          : 'UI.DataFieldForIntentBasedNavigation',
                SemanticObject : 'Customer',
                Action         : 'display',
                Label          : '{i18n>DisplayCustomers}',
                RequiresContext: false,
                Mapping        : [{
                    $Type                 : 'Common.SemanticObjectMappingType',
                    LocalProperty         : to_Customer_CustomerID,
                    SemanticObjectProperty: 'CustomerID',
                }]
            }
        ],
        Facets                : [
            {
                $Type : 'UI.CollectionFacet',
                Label : '{i18n>GeneralInformation}',
                ID    : 'Travel',
                Facets: [
                    { // travel details
                        $Type : 'UI.ReferenceFacet',
                        ID    : 'TravelData',
                        Target: '@UI.FieldGroup#TravelData',
                        Label : '{i18n>GeneralInformation}'
                    },
                    {
                        $Type            : 'UI.ReferenceFacet',
                        Label            : '{i18n>TravelAdministrativeData}',
                        ID               : 'TravelAdministrativeData',
                        Target           : '@UI.FieldGroup#TravelAdministrativeData',
                        @UI.PartOfPreview: false,
                    },
                ]
            },
            { // booking list
                $Type : 'UI.ReferenceFacet',
                Target: 'to_Booking/@UI.PresentationVariant',
                Label : '{i18n>Bookings}'
            }
        ],
        FieldGroup #TravelData: {Data: [
            {Value: TravelID},
            {Value: to_Agency_AgencyID},
            {Value: to_Customer_CustomerID},
            {Value: Description},
            {
                $Type        : 'UI.DataField',
                Value        : BeginDate,
                ![@UI.Hidden]: TravelStatus.cancelRestrictions,
            },
            {
                $Type        : 'UI.DataField',
                Value        : EndDate,
                ![@UI.Hidden]: TravelStatus.cancelRestrictions,
            },
        ]},
        FieldGroup #DateData  : {Data: [
            {
                $Type: 'UI.DataField',
                Value: BeginDate
            },
            {
                $Type: 'UI.DataField',
                Value: EndDate
            }
        ]}
    },
    UI.DataPoint #Progress                 : {
        Value        : Progress,
        Visualization: #Progress,
        TargetValue  : 100,
    },
    UI.SelectionPresentationVariant #table : {
        $Type              : 'UI.SelectionPresentationVariantType',
        PresentationVariant: ![@UI.PresentationVariant],
        SelectionVariant   : {
            $Type        : 'UI.SelectionVariantType',
            SelectOptions: [],
        },
    },
    UI.DataPoint #TravelStatus_code        : {
        $Type      : 'UI.DataPointType',
        Value      : TravelStatus_code,
        Title      : '{i18n>TravelStatus}',
        Criticality: TravelStatus.criticality,
    },
    UI.HeaderFacets                        : [
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'TravelStatus_code',
            Target: '@UI.DataPoint#TravelStatus_code',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'TotalPrice',
            Target: '@UI.DataPoint#TotalPrice',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID    : 'Progress',
            Target: '@UI.DataPoint#progress',
        },
    ],
    UI.DataPoint #TotalPrice               : {
        $Type: 'UI.DataPointType',
        Value: TotalPrice,
        Title: '{i18n>TotalPrice}',
    },
    UI.DataPoint #progress                 : {
        $Type        : 'UI.DataPointType',
        Value        : Progress,
        Title        : '{i18n>Progress}',
        TargetValue  : 100,
        Visualization: #Progress,
    },
    UI.DataPoint #TotalPrice1              : {
        Value       : TotalPrice,
        MinimumValue: 0,
        MaximumValue: 120,
    },
    UI.Chart #TotalPrice                   : {
        ChartType        : #Bullet,
        Title            : '{i18n>TotalPrice}',
        Measures         : [TotalPrice, ],
        MeasureAttributes: [{
            DataPoint: '@UI.DataPoint#TotalPrice1',
            Role     : #Axis1,
            Measure  : TotalPrice,
        }, ],
    },
    UI.FieldGroup #TravelAdministrativeData: {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: createdAt,
            },
            {
                $Type: 'UI.DataField',
                Value: createdBy,
            },
            {
                $Type: 'UI.DataField',
                Value: LastChangedAt,
            },
            {
                $Type: 'UI.DataField',
                Value: LastChangedBy,
            },
        ],
    },
    Analytics.AggregatedProperty #TravelID_countdistinct : {
        $Type : 'Analytics.AggregatedPropertyType',
        Name : 'TravelID_countdistinct',
        AggregatableProperty : TravelID,
        AggregationMethod : 'countdistinct',
        @Common.Label : '{i18n>DistinctTravels}',
    },
    UI.Chart #alpChart : {
        $Type : 'UI.ChartDefinitionType',
        ChartType : #Column,
        Dimensions : [
            PassengerCountry,
        ],
        DynamicMeasures : [
            '@Analytics.AggregatedProperty#TravelID_countdistinct',
        ],
        Title : 'Travels by Customer Country',
    },
    UI.Chart #visualFilter : {
        $Type : 'UI.ChartDefinitionType',
        ChartType : #Bar,
        Dimensions : [
            to_Agency_AgencyID,
        ],
        DynamicMeasures : [
            '@Analytics.AggregatedProperty#TravelID_countdistinct',
        ],
    },
    UI.PresentationVariant #visualFilter : {
        $Type : 'UI.PresentationVariantType',
        Visualizations : [
            '@UI.Chart#visualFilter',
        ],
    },
    UI.Chart #visualFilter1 : {
        $Type : 'UI.ChartDefinitionType',
        ChartType : #Bar,
        Dimensions : [
            to_Customer_CustomerID,
        ],
        DynamicMeasures : [
            '@Analytics.AggregatedProperty#TravelID_countdistinct',
        ],
    },
    UI.PresentationVariant #visualFilter1 : {
        $Type : 'UI.PresentationVariantType',
        Visualizations : [
            '@UI.Chart#visualFilter1',
        ],
    },
    UI.Chart #visualFilter2 : {
        $Type : 'UI.ChartDefinitionType',
        ChartType : #Line,
        Dimensions : [
            BeginDate,
        ],
        DynamicMeasures : [
            '@Analytics.AggregatedProperty#TravelID_countdistinct',
        ],
    },
    UI.PresentationVariant #visualFilter2 : {
        $Type : 'UI.PresentationVariantType',
        Visualizations : [
            '@UI.Chart#visualFilter2',
        ],
    },
);

annotate TravelService.Booking with @(
    UI                            : {
        Identification                : [{Value: BookingID}, ],
        HeaderInfo                    : {
            TypeName      : '{i18n>Bookings}',
            TypeNamePlural: '{i18n>Bookings}',
            Title         : {Value: to_Customer.LastName},
            Description   : {Value: BookingID}
        },
        PresentationVariant           : {
            Visualizations: ['@UI.LineItem'],
            SortOrder     : [{
                $Type     : 'Common.SortOrderType',
                Property  : BookingID,
                Descending: false
            }]
        },
        SelectionFields               : [],
        LineItem                      : [
            {
                Value: to_Carrier.AirlinePicURL,
                Label: '  '
            },
            {Value: BookingID},
            {Value: BookingDate},
            {Value: to_Customer_CustomerID},
            {Value: to_Carrier_AirlineID},
            {
                Value: ConnectionID,
                Label: '{i18n>FlightNumber}'
            },
            {Value: FlightDate},
            {Value: FlightPrice},
            {Value: BookingStatus_code},
            {
                $Type : 'UI.DataFieldForAnnotation',
                Target: '@UI.Chart#TotalSupplPrice',
                Label : '{i18n>Totalsupplprice}',
            },
        ],
        Facets                        : [
            {
                $Type : 'UI.CollectionFacet',
                Label : '{i18n>GeneralInformation}',
                ID    : 'Booking',
                Facets: [
                    { // booking details
                        $Type : 'UI.ReferenceFacet',
                        ID    : 'BookingData',
                        Target: '@UI.FieldGroup#GeneralInformation',
                        Label : '{i18n>Booking}'
                    },
                    { // flight details
                        $Type : 'UI.ReferenceFacet',
                        ID    : 'FlightData',
                        Target: '@UI.FieldGroup#Flight',
                        Label : '{i18n>Flight}'
                    }
                ]
            },
            { // supplements list
                $Type : 'UI.ReferenceFacet',
                Target: 'to_BookSupplement/@UI.PresentationVariant',
                Label : '{i18n>BookingSupplements}'
            }
        ],
        FieldGroup #GeneralInformation: {Data: [
            {Value: BookingID},
            {Value: BookingDate, },
            {Value: to_Customer_CustomerID},
            {Value: BookingDate, },
            {Value: BookingStatus_code}
        ]},
        FieldGroup #Flight            : {Data: [
            {Value: to_Carrier_AirlineID},
            {Value: ConnectionID},
            {Value: FlightDate},
            {Value: FlightPrice}
        ]},
    },
    UI.DataPoint #TotalSupplPrice : {
        Value       : TotalSupplPrice,
        MinimumValue: 0,
        MaximumValue: 120,
    },
    UI.Chart #TotalSupplPrice     : {
        ChartType        : #Bullet,
        Measures         : [TotalSupplPrice, ],
        MeasureAttributes: [{
            DataPoint: '@UI.DataPoint#TotalSupplPrice',
            Role     : #Axis1,
            Measure  : TotalSupplPrice,
        }, ],
    },
    UI.DataPoint #TotalSupplPrice1: {
        Value                 : TotalSupplPrice,
        MinimumValue          : {$edmJson: {$Path: '/SupplementScope/MinimumValue'}},
        MaximumValue          : {$edmJson: {$Path: '/SupplementScope/MaximumValue'}},
        TargetValue           : {$edmJson: {$Path: '/SupplementScope/TargetValue'}},
        Visualization         : #BulletChart,
        // Criticality : TotalSupplPrice, // it has precedence over criticalityCalculation => in order to have the   criticality       color do not use it
        CriticalityCalculation: {
            $Type                 : 'UI.CriticalityCalculationType',
            ImprovementDirection  : #Maximize,
            DeviationRangeLowValue: {$edmJson: {$Path: '/SupplementScope/DeviationRangeLowValue'}},
            ToleranceRangeLowValue: {$edmJson: {$Path: '/SupplementScope/ToleranceRangeLowValue'}}
        }
    },
    UI.Chart #TotalSupplPrice1    : {
        ChartType        : #Bullet,
        Title            : '{i18n>Totalsupplprice}',
        Measures         : [TotalSupplPrice, ],
        MeasureAttributes: [{
            DataPoint: '@UI.DataPoint#TotalSupplPrice1',
            Role     : #Axis1,
            Measure  : TotalSupplPrice,
        }, ],
    },
    UI.HeaderFacets               : [{
        $Type : 'UI.ReferenceFacet',
        ID    : 'TotalSupplPrice',
        Target: '@UI.Chart#TotalSupplPrice1',
    }, ],
);

annotate TravelService.BookingSupplement with @UI: {
    Identification     : [{Value: BookingSupplementID}],
    HeaderInfo         : {
        TypeName      : '{i18n>BookingSupplement}',
        TypeNamePlural: '{i18n>BookingSupplements}',
        Title         : {Value: BookingSupplementID},
        Description   : {Value: BookingSupplementID}
    },
    PresentationVariant: {
        Text          : 'Default',
        Visualizations: ['@UI.LineItem'],
        SortOrder     : [{
            $Type     : 'Common.SortOrderType',
            Property  : BookingSupplementID,
            Descending: false
        }]
    },
    LineItem           : [
        {Value: BookingSupplementID},
        {
            Value: to_Supplement_SupplementID,
            Label: '{i18n>ProductID}'
        },
        {
            Value: Price,
            Label: '{i18n>ProductPrice}'
        }
    ],
};

annotate TravelService.Flight with @UI: {PresentationVariant #SortOrderPV: { // used in the value help for ConnectionId in Bookings
SortOrder: [{
    Property  : FlightDate,
    Descending: true
}]}};

annotate TravelService.TravelAgency with @(Communication.Contact #contact: {
    $Type: 'Communication.ContactType',
    fn   : Name,
    tel  : [{
        $Type: 'Communication.PhoneNumberType',
        type : #work,
        uri  : PhoneNumber,
    }, ],
    adr  : [{
        $Type   : 'Communication.AddressType',
        type    : #work,
        street  : Street,
        locality: City,
        code    : PostalCode,
        country : CountryCode.name,
    }, ],
});

annotate TravelService.Travel with @UI: {
    SelectionVariant #canceled: {
        $Type           : 'UI.SelectionVariantType',
        ID              : 'canceled',
        Text            : '{i18n>Canceled}',
        Parameters      : [

        ],
        FilterExpression: '',
        SelectOptions   : [{
            $Type       : 'UI.SelectOptionType',
            PropertyName: TravelStatus_code,
            Ranges      : [{
                $Type : 'UI.SelectionRangeType',
                Sign  : #I,
                Option: #EQ,
                Low   : 'X',
            }, ],
        }, ],
    },
    SelectionVariant #open    : {
        $Type           : 'UI.SelectionVariantType',
        ID              : 'open',
        Text            : '{i18n>Open}',
        Parameters      : [

        ],
        FilterExpression: '',
        SelectOptions   : [{
            $Type       : 'UI.SelectOptionType',
            PropertyName: TravelStatus_code,
            Ranges      : [{
                $Type : 'UI.SelectionRangeType',
                Sign  : #I,
                Option: #EQ,
                Low   : 'O',
            }, ],
        }, ],
    },
    SelectionVariant #accepted: {
        $Type           : 'UI.SelectionVariantType',
        ID              : 'accepted',
        Text            : '{i18n>Accepted}',
        Parameters      : [

        ],
        FilterExpression: '',
        SelectOptions   : [{
            $Type       : 'UI.SelectOptionType',
            PropertyName: TravelStatus_code,
            Ranges      : [{
                $Type : 'UI.SelectionRangeType',
                Sign  : #I,
                Option: #EQ,
                Low   : 'A',
            }, ],
        }, ],
    }
};

annotate TravelService.Travel with {
    Description @UI.MultiLineText: true
                @UI.Placeholder  : '{i18n>DescrPlcehlder}'
}

annotate TravelService.Booking with {
    ConnectionID @(
        Common.ValueList               : {
            CollectionPath              : 'Flight',
            Label                       : '',
            Parameters                  : [
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    ValueListProperty: 'AirlineID',
                    LocalDataProperty: to_Carrier_AirlineID,
                },
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    LocalDataProperty: ConnectionID,
                    ValueListProperty: 'ConnectionID',
                },
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    ValueListProperty: 'FlightDate',
                    LocalDataProperty: FlightDate,
                },
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    ValueListProperty: 'Price',
                    LocalDataProperty: FlightPrice,
                },
                {
                    $Type            : 'Common.ValueListParameterInOut',
                    ValueListProperty: 'CurrencyCode_code',
                    LocalDataProperty: CurrencyCode_code,
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'to_Airline/Name',
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'PlaneType',
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'MaximumSeats',
                },
                {
                    $Type            : 'Common.ValueListParameterDisplayOnly',
                    ValueListProperty: 'OccupiedSeats',
                },
            ],
            PresentationVariantQualifier: 'SortOrderPV',
        },
        Common.ValueListWithFixedValues: true,
    )
};

annotate TravelService.Travel @(Common.SideEffects #ReactonItemCreationOrDeletion: {
    SourceEntities  : [to_Booking],
    TargetProperties: ['TotalPrice']
});

annotate TravelService.Travel with {
    @(Common: {
        SemanticObject       : 'Customer',
        SemanticObjectMapping: [{
            LocalProperty         : to_Customer_CustomerID,
            SemanticObjectProperty: 'CustomerID'
        }]
    },
        Common.ValueList #visualFilter : {
            $Type : 'Common.ValueListType',
            CollectionPath : 'Travel',
            Parameters : [
                {
                    $Type : 'Common.ValueListParameterInOut',
                    LocalDataProperty : to_Customer_CustomerID,
                    ValueListProperty : 'to_Customer_CustomerID',
                },
            ],
            PresentationVariantQualifier : 'visualFilter1',
        },)
    to_Customer
};
annotate TravelService.Travel with {
    PassengerCountry @Common.Label : '{i18n>Customercountry}'
};

annotate TravelService.Travel with {
    to_Agency @Common.ValueList #visualFilter : {
        $Type : 'Common.ValueListType',
        CollectionPath : 'Travel',
        Parameters : [
            {
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : to_Agency_AgencyID,
                ValueListProperty : 'to_Agency_AgencyID',
            },
        ],
        PresentationVariantQualifier : 'visualFilter',
    }
};

annotate TravelService.Travel with {
    BeginDate @Common.ValueList #visualFilter : {
        $Type : 'Common.ValueListType',
        CollectionPath : 'Travel',
        Parameters : [
            {
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : BeginDate,
                ValueListProperty : 'BeginDate',
            },
        ],
        PresentationVariantQualifier : 'visualFilter2',
    }
};

