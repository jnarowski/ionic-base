angular.module 'karmacrm.contacts.form', [
  'karmacrm.contacts'
]
.config ($stateProvider) ->
  $stateProvider.state 'app.contacts.form',
    abstract: yes
    url: ''
    controller: 'ContactFormCtrl'
    template: '<ion-nav-view/>'


.controller 'ContactFormCtrl', () -> return

.factory 'ContactDestroyableLists', (DestroyableList, PhoneEntity, EmailEntity, SocialAccountEntity, WebsiteEntity, AddressEntity, TagEntity) ->
  destroyableList =
    lists: {}
    create: ($scope) ->
      destroyableList.lists.phone = new DestroyableList $scope, $scope.editedContact.phone_numbers, PhoneEntity
      destroyableList.lists.email = new DestroyableList $scope, $scope.editedContact.emails, EmailEntity
      destroyableList.lists.socialAccount = new DestroyableList $scope, $scope.editedContact.social_accounts, SocialAccountEntity
      destroyableList.lists.website = new DestroyableList $scope, $scope.editedContact.websites, WebsiteEntity
      destroyableList.lists.address = new DestroyableList $scope, $scope.editedContact.addresses, AddressEntity
      destroyableList.lists.tag = new DestroyableList $scope, $scope.editedContact.tag_list, TagEntity
    destroy: () ->
      destroyableList.lists.phone.destroy()
      destroyableList.lists.email.destroy()
      destroyableList.lists.socialAccount.destroy()
      destroyableList.lists.website.destroy()
      destroyableList.lists.address.destroy()
      destroyableList.lists.tag.destroy()
      destroyableList.clear()
    clear: () ->
      destroyableList.lists.phone = null
      destroyableList.lists.email = null
      destroyableList.lists.socialAccount = null
      destroyableList.lists.website = null
      destroyableList.lists.address = null
      destroyableList.lists.tag = null
  destroyableList.clear()
  destroyableList

.factory 'ContactFormMixin', (Server,
    CompanyRepository, IndustryRepository, ReferralSourcesRepository, PhoneTypesRepository, EmailTypesRepository,
    SocialAccountTypesRepository,WebsiteTypesRepository, AddressTypesRepository, CountryRepository, UserRepository,
    ContactStageRepository, ContactStatusRepository,
    Selector, CustomFieldRepository) ->

  mixin =
    customFields: CustomFieldRepository
    avatarRoot: Server.domainRoot

    selectCompany: (editedContact) ->
      Selector.show
        title: 'Select a Company'
        selected: editedContact.company?.id ? 0
        filterFn: CompanyRepository.filter
      .then (company) ->
        editedContact.company = company

    selectIndustry: (editedContact) ->
      Selector.show
        title: 'Select an Industry'
        selected: editedContact.industry_id
        items: IndustryRepository.all()
      .then (industry) ->
        editedContact.industry_id = industry.id

    selectReferralSource: (editedContact) ->
      Selector.show
        title: 'Select a Referral Source'
        selected: editedContact.referral_source_id
        items: ReferralSourcesRepository.all()
      .then (source) ->
        editedContact.referral_source_id = source.id

    selectPhoneType: (phone) ->
      Selector.show
        title: 'Select a Phone Type'
        selected: phone.phone_number_type_id
        items: PhoneTypesRepository.all()
      .then (phoneType) ->
        phone.phone_number_type_id = phoneType.id

    selectEmailType: (email) ->
      Selector.show
        title: 'Select an Email Type'
        selected: email.secondary_email_type_id
        items: EmailTypesRepository.all()
      .then (emailType) ->
        email.secondary_email_type_id = emailType.id

    selectSocialAccountType: (socialAccount) ->
      Selector.show
        title: 'Select a Social Account Type'
        selected: socialAccount.social_account_type_id
        items: SocialAccountTypesRepository.all()
      .then (socialAccountType) ->
        socialAccount.social_account_type_id = socialAccountType.id

    selectWebsiteType: (website) ->
      Selector.show
        title: 'Select a Website Type'
        selected: website.secondary_website_type_id
        items: WebsiteTypesRepository.all()
      .then (websiteType) ->
        website.secondary_website_type_id = websiteType.id

    selectAddressType: (address) ->
      Selector.show
        title: 'Select an Address Type'
        selected: address.address_type
        items: AddressTypesRepository.all()
      .then (addressType) ->
        address.address_type = addressType.id

    selectCountry: (address) ->
      Selector.show
        title: 'Select a Country'
        selected: address.country
        items: CountryRepository.all()
      .then (country) ->
        address.country = country.id

    selectUser: (editedContact) ->
      Selector.show
        title: 'Select a User'
        selected: editedContact.user_id
        items: UserRepository.all()
      .then (user) ->
        editedContact.user_id = user.id

    selectContactStage: (editedContact) ->
      Selector.show
        title: 'Select a Contact Stage'
        selected: editedContact.lead_process_id
        items: ContactStageRepository.all()
      .then (contactStage) ->
        editedContact.lead_process_id = contactStage.id

    selectContactStatus: (editedContact) ->
      Selector.show
        title: 'Select a Contact Status'
        selected: editedContact.lead_status_id
        items: ContactStatusRepository.all()
      .then (contactStatus) ->
        editedContact.lead_status_id = contactStatus.id
