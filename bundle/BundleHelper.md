## Overview

The BundleHelper is a utility to assist bundle developers. Basically a grab bag of methods that don't fit into other helper.

## Files

[bundle/BundleHelper.md](BundleHelper.md)  
README file containing information on configuring and using the bundle helper.

[bundle/BundleHelper.jspf](BundleHelper.jspf)  
Helper file containing definitions for the BundleHelper.  More information can be found in
the [BundleHelper Summary] section below.

## Configuration

* Copy the files listed above into your bundle
* Initialize the BundleHelper in your bundle/initialization.jspf file

### Initialize the BundleHelper

**bundle/initialization.jspf**
```jsp
<%-- BundleHelper --%>
<%@include file="BundleHelper.jspf"%>
<%
    request.setAttribute("BundleHelper", new BundleHelper(bundle, kapp, space));
%>
```

---

#### BundleHelper Constructor Summary
| Signature                                                                         | Description                                                                                                                   |
| :-------------------------------------------------------------------------------- | :---------------------------------------------------------------------------------------------------------------------------- |
| `BundleHelper()`                                                                  | Constructs a newly allocated BundleHelper object to assist bundle developers.                                                 |

---
#### BundleHelper Helper Classes
| Signature                                                                         | Description                                                                                                                   |
| :-------------------------------------------------------------------------------- | :---------------------------------------------------------------------------------------------------------------------------- |
| `HeaderNavigationLink`                                                            | Constructs that provides getName and getPath methods.                                                                         |

---
#### SubmissionHelper Method Summary
| Signature                                                                         | Description                                                                                                                   |
| :-------------------------------------------------------------------------------- | :---------------------------------------------------------------------------------------------------------------------------- |
| `List<HeaderNavigationLink> getHeaderNavigation()`                                | Use the kapp or space attribute "Header Navigation List" and a JSON value to build a list of URLs for use in the bundle.      |
| `String getLogo(Kapp kapp)`                                                       | Use the kapp attribute "Company Logo" to build a relative or absolute URL (based on the existence of "Http") to an image file.|
| `boolean hasForm(String kapp, String form)`                                       | Given a kapp and a form the method returns true/false if it exist.  The form must be in an "Active" state                     |
