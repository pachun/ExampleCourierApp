class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    Courier::nuke.everything.right.now
    Courier::Courier.instance.tap do |courier|
      courier.parcels = [User, Post]
      courier.url = "http://jsonplaceholder.typicode.com"
    end

    user_list_controller = UserListController.new
    nav_controller = UINavigationController.alloc.
      initWithRootViewController(user_list_controller)

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = nav_controller
    @window.makeKeyAndVisible
    true
  end
end
