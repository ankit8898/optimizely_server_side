# 0.0.15

JSON schema validation was making things slow. We are turning it off permanently
as the JSON is being downloaded from CDN

The skip_json_validation property should only be used if the datafile is being pulled from the REST API or CDN.

# 0.0.14

Added a Omniture tag for tracking in erb

# 0.0.13

- Adding support for adding additional attributes via experiments.
- Adding a feature_flip method which is alias of experiment to distinguish between experiments and on/off feature.


# 0.0.11

Bug fix. Visitor id should not be passed in attributes.

# 0.0.10

Introduced the `user_attributes` option which takes care of passing visitor_id and custom attributes that will be required for Audience level bucketing.

# 0.0.9

Event dispatcher can now be passed as option.
