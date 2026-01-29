import ControllerExtension from 'sap/ui/core/mvc/ControllerExtension';
import ExtensionAPI from 'sap/fe/templates/ObjectPage/ExtensionAPI';
import Message from 'sap/ui/core/message/Message';
import MessageType from 'sap/ui/core/message/MessageType';
import type ODataModel from "sap/ui/model/odata/v4/ODataModel";
import type Context from "sap/ui/model/odata/v4/Context";
import type ResourceModel from "sap/ui/model/resource/ResourceModel";
import type ResourceBundle from "sap/base/i18n/ResourceBundle";
import JSONModel from 'sap/ui/model/json/JSONModel';


/**
 * @namespace sap.fe.cap.customer.ext.controller
 * @controller
 */
export default class PassengerOPExtend extends ControllerExtension<ExtensionAPI> {
	message: string | undefined;

	static overrides = {
		/**
		 * Called when a controller is instantiated and its View controls (if available) are already created.
		 * Can be used to modify the View before it is displayed, to bind event handlers and do other one-time initialization.
		 * @memberOf sap.fe.cap.customer.ext.controller.PassengerOPExtend
		 */
		onInit(this: PassengerOPExtend) {
			// you can access the Fiori elements extensionAPI via this.base.getExtensionAPI
			const model = this.base.getExtensionAPI().getModel();
		},
		routing: {
			onAfterBinding: async function (this: PassengerOPExtend, oBindingContext: Context) {
				const oExtensionAPI = this.base.getExtensionAPI();
				const oModel = oExtensionAPI.getModel() as ODataModel;

				const i18nModel = oExtensionAPI.getModel("i18n") as ResourceModel;
				const rb = i18nModel.getResourceBundle() as ResourceBundle;

				const oBookingTableAPI: any = oExtensionAPI.byId(
					"fe::CustomSubSection::Bookings--OwnBookingsTable"
				);
				const oPassengerBookingsModel = new JSONModel({
					totalBookingsCount: 0,
					newBookingsCount: 0,
					acceptedBookingsCount: 0,
					cancelledBookingsCount: 0
				})
				this.base.getView().setModel(oPassengerBookingsModel, "passengerBookingsModel");

				try {
					// Encja z aktualnego kontekstu (np. Passenger/Customer)
					const oCustomer = (await oBindingContext.requestObject()) as {
						CustomerID: string;
					};

					// Przygotowanie i wywołanie funkcji OData v4: /getBookingDataOfPassenger(...)
					const sFunctionName = "getBookingDataOfPassenger";
					const oFunction = oModel.bindContext(`/${sFunctionName}(...)`);
					oFunction.setParameter("CustomerID", oCustomer.CustomerID);

					await oFunction.execute();
					const oResponseCtx = oFunction.getBoundContext();
					if (!oResponseCtx) return;

					oPassengerBookingsModel.setProperty("/totalBookingsCount", oResponseCtx.getProperty("TotalBookingsCount"));
					oPassengerBookingsModel.setProperty("/newBookingsCount", oResponseCtx.getProperty("NewBookingsCount"));
					oPassengerBookingsModel.setProperty("/acceptedBookingsCount", oResponseCtx.getProperty("AcceptedBookingsCount"));
					oPassengerBookingsModel.setProperty("/cancelledBookingsCount", oResponseCtx.getProperty("CancelledBookingsCount"));

					// Usuń poprzednią wiadomość, jeśli była dodana
					if (this.message && oBookingTableAPI?.removeMessage) {
						oBookingTableAPI.removeMessage(this.message);
						this.message = undefined;
					}

					if (oResponseCtx.getProperty("NewBookingsCount") > 0 && oBookingTableAPI?.addMessage) {
						const warnMsg = new Message({
							type: MessageType.Warning,
							message: rb.getText("bookingsNew"),
						});
						const infoMsg = new Message({
							type: MessageType.Information,
							message: rb.getText("bookingsAttention"),
						});

						// Dodaj alert do widżetu tabeli + pokaż wiadomości w pasku
						this.message = oBookingTableAPI.addMessage(warnMsg);
						oExtensionAPI.showMessages([infoMsg]);
					}
				} catch (err) {
					// Log lub obsługa przez FE
					// eslint-disable-next-line no-console
					console.error("onAfterBinding failed:", err);
				}

			}
		}
	}
}