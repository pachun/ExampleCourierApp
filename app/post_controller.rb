class PostController < UIViewController
  def initWithPost(post)
    init.tap do
      @post = post
    end
  end

  def viewDidLoad
    super
    view.backgroundColor = UIColor.whiteColor
    navigationItem.title = @post.title
    add_post_text
  end

  private

  def add_post_text
    UILabel.alloc.initWithFrame([[0,0],[320,568]]).tap do |l|
      l.numberOfLines = 0
      l.text = @post.body
      view.addSubview(l)
    end
  end
end
