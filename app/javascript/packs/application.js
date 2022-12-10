/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs";
import Turbolinks from "turbolinks";
import * as ActiveStorage from "@rails/activestorage";
import "channels";
import "bootstrap";
import "./answer";
import "../../assets/stylesheets/application.scss";
import "@popperjs/core";
import "./question";
import "jquery";
import "@nathanvda/cocoon";
import "./votes";
import createConsumer from "../channels/consumer";

//import {createConsumer} from "@rails/actioncable";

//window.App = window.App || {};
//window.App.cable = createConsumer();

const GistClient = require("gist-client");
const gistClient = new GistClient();


Rails.start();
Turbolinks.start();
ActiveStorage.start();
window.gistClient = gistClient;
