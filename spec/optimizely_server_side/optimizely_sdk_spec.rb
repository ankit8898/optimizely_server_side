require 'spec_helper'

RSpec.describe OptimizelyServerSide::OptimizelySdk do

  let(:valid_datafile) do
    '{
      "experiments": [{
                        "status": "Paused",
                        "percentageIncluded": 10000,
                        "key": "PROPERTY_HISTORY_TEST",
                        "trafficAllocation": [{
                                                "entityId": "6038700472",
                                                "endOfRange": 2500
                                              }, {
                                                "entityId": "6038700473",
                                                "endOfRange": 7500
                                              }, {
                                                "entityId": "6038700474",
                                                "endOfRange": 10000
                        }],
                        "audienceIds": [],
                        "variations": [{
                                         "id": "6038700472",
                                         "key": "PROPERTY_HISTORY_IMAGE_ONE"
                                       }, {
                                         "id": "6038700473",
                                         "key": "PROPERTY_HISTORY_IMAGE_TWO"
                                       }, {
                                         "id": "6038700474",
                                         "key": "DEFAULT"
                        }],
                        "forcedVariations": {},
                        "id": "6051271599"
                      }, {
                        "status": "Archived",
                        "percentageIncluded": 10000,
                        "key": "FS_SRP_MapPlusListView",
                        "trafficAllocation": [{
                                                "entityId": "6236690179",
                                                "endOfRange": 10000
                        }],
                        "audienceIds": [],
                        "variations": [{
                                         "id": "6236690179",
                                         "key": "MapViewPlusList"
                        }],
                        "forcedVariations": {},
                        "id": "6240360321"
                      }, {
                        "status": "Running",
                        "percentageIncluded": 10000,
                        "key": "MAPVERTISING",
                        "trafficAllocation": [{
                                                "entityId": "6832840236",
                                                "endOfRange": 3000
                                              }, {
                                                "entityId": "6832840237",
                                                "endOfRange": 10000
                        }],
                        "audienceIds": [],
                        "variations": [{
                                         "id": "6832840236",
                                         "key": "VERSION_A"
                                       }, {
                                         "id": "6832840237",
                                         "key": "VERSION_B"
                        }],
                        "forcedVariations": {},
                        "id": "6839510990"
      }],
      "version": "1",
      "audiences": [],
      "dimensions": [{
                       "id": "6202664479",
                       "key": "geography",
                       "segmentId": "6236461184"
      }],
      "groups": [],
      "projectId": "5960232316",
      "accountId": "5955320306",
      "events": [{
                   "experimentIds": ["6051271599"],
                   "id": "6048790108",
                   "key": "Property history image check goal"
                 }, {
                   "experimentIds": ["6240360321"],
                   "id": "6231170981",
                   "key": "MapTest"
                 }, {
                   "experimentIds": ["6839510990"],
                   "id": "6813060279",
                   "key": "MAPVERTISING_GOAL"
                 }, {
                   "experimentIds": [],
                   "id": "5927811380",
                   "key": "Total Revenue"
      }],
      "revision": "23"
    }'
  end

  describe '.project_instance' do

    before do
      stub_request(:get, "https://cdn.optimizely.com/json/5960232316.json")
      .to_return(body: valid_datafile, status: 200)
    end

    it 'returns an OptimizelySdk project instance' do
      expect(described_class.project_instance).to be_kind_of(Optimizely::Project)
    end
  end
end
