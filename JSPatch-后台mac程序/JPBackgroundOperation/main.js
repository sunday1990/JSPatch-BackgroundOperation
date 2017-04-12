
//http://jspatch.com/Docs/SDK

//https://github.com/bang590/JSPatch

require("RegistViewController");
//include('ad.js')
defineClass("LoginViewController", {
            rightNavButtonClick: function(button) {
            
            var slf = self;
            
            console.log("success realod function---> rightNavButtonClick:");
            
            var registVC = RegistViewController.alloc().init();
            
            var weakregistVC = __weak(registVC);
            
            registVC.setSuccessRegist(block("id", function() {
                                            
                                            weakregistVC.dismissViewControllerAnimated_completion(YES, null);
                                            
                                            var blk = slf.loginSuccess();
                                            
                                            console.log("will login");
                                            
                                            if (blk) {
                                            
                                            console.log("did login");
                                            
                                            blk();
                                            
                                            }else{
                                            
                                            console.log("fail login");
                                            }
                                            
                                            }));
            slf.presentViewController_animated_completion(registVC, YES, null);
            
            }
            }, {});

defineClass("RegistViewController", {
            
            backButtonClick: function(button) {
            
            self.super().backButtonClick(button);
            
            self.dismissViewControllerAnimated_completion(YES, null);
            }
            
            }, {});

defineClass("SHForgetPwdViewController", {
            backButtonClick: function(button) {
            
            self.super().backButtonClick(button);
            
            self.dismissViewControllerAnimated_completion(YES, null);
            
            }
            
            }, {});


