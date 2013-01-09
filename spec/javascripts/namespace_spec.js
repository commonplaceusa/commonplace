describe("Namespace Sanity", function() {
  beforeEach(function() {
  });

  it("CommonPlace namespace should be defined", function() {
    expect(CommonPlace).toBeDefined();
  });
  it("CommonPlace.main namespace should be defined", function() {
    expect(CommonPlace.main).toBeDefined();
  });
  it("CommonPlace.pages namespace should be defined", function() {
    expect(CommonPlace.pages).toBeDefined();
  });
  it("CommonPlace.shared namespace should be defined", function() {
    expect(CommonPlace.shared).toBeDefined();
  });
  it("CommonPlace.registration namespace should be defined", function() {
    expect(CommonPlace.registration).toBeDefined();
  });
  it("CommonPlace.views namespace should be defined", function() {
    expect(CommonPlace.views).toBeDefined();
  });
  it("CommonPlace.wire_item namespace should be defined", function() {
    expect(CommonPlace.wire_item).toBeDefined();
  });
});
